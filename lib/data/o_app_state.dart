import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/intention.dart';
import '../models/purpose.dart';
import '../models/session.dart';
import 'o_companion.dart';
import 'o_store.dart';
import 'presence.dart';

const sessionKey = 'o.session';
const purposesKey = 'o.purposes';
const intentionsKey = 'o.intentions';

class OAppState extends ChangeNotifier {
  OAppState({required this.store, required this.companion, Random? random})
    : _random = random ?? Random();

  final OStore store;
  final OCompanion companion;
  final Random _random;

  bool ready = false;
  LocalSession? session;
  List<Purpose> purposes = const [];
  List<Intention> intentions = const [];
  String? focusedPurposeId;

  String? get sessionName {
    final name = session?.displayName.trim();
    if (name == null || name.isEmpty) return null;
    return name;
  }

  Purpose? get focusedPurpose {
    if (purposes.isEmpty) return null;
    if (focusedPurposeId != null) {
      final found = purposeById(focusedPurposeId!);
      if (found != null) return found;
    }
    return purposes.first;
  }

  Future<void> hydrate() async {
    final rawSession = await store.read(sessionKey);
    final rawPurposes = await store.read(purposesKey);
    final rawIntentions = await store.read(intentionsKey);
    if (rawSession != null) {
      session = LocalSession.fromJson(
        jsonDecode(rawSession) as Map<String, dynamic>,
      );
    }
    if (rawPurposes != null) {
      final list = jsonDecode(rawPurposes) as List<dynamic>;
      purposes = list
          .map((row) => Purpose.fromJson(row as Map<String, dynamic>))
          .toList();
    }
    if (rawIntentions != null) {
      final list = jsonDecode(rawIntentions) as List<dynamic>;
      intentions = list
          .map((row) => Intention.fromJson(row as Map<String, dynamic>))
          .toList();
    }
    focusedPurposeId = focusedPurpose?.id;
    ready = true;
    await _scrubPresence(persist: true);
    notifyListeners();
  }

  Future<void> enterLocal({required String displayName}) async {
    final name = displayName.trim().isEmpty ? 'You' : displayName.trim();
    session = LocalSession(
      id: _id('ses'),
      displayName: name,
      startedAt: DateTime.now(),
    );
    await store.write(sessionKey, jsonEncode(session!.toJson()));
    await _scrubPresence(persist: true);
    notifyListeners();
  }

  Future<void> leave() async {
    session = null;
    await store.delete(sessionKey);
    notifyListeners();
  }

  void focusPurpose(String id) {
    if (purposeById(id) == null) return;
    focusedPurposeId = id;
    notifyListeners();
  }

  Future<void> addPurpose({required String title, required String why}) async {
    final trimmedTitle = title.trim();
    final trimmedWhy = why.trim();
    if (trimmedTitle.isEmpty || trimmedWhy.isEmpty) {
      throw ArgumentError('A purpose needs a name and a why.');
    }
    final purpose = Purpose(
      id: _id('pur'),
      title: trimmedTitle,
      why: trimmedWhy,
      createdAt: DateTime.now(),
    );
    purposes = [purpose, ...purposes];
    focusedPurposeId = purpose.id;
    await _persistPurposes();
  }

  Future<void> addIntention({
    required String purposeId,
    required String title,
    required String statement,
    String? whenLabel,
    List<String> people = const [],
    bool commit = false,
  }) async {
    final trimmedTitle = title.trim();
    final trimmedStatement = statement.trim();
    if (trimmedTitle.isEmpty || trimmedStatement.isEmpty) {
      throw ArgumentError('An intention needs a title and a statement.');
    }
    if (purposeById(purposeId) == null) {
      throw ArgumentError('An intention belongs to a purpose.');
    }
    final intention = Intention(
      id: _id('int'),
      purposeId: purposeId,
      title: trimmedTitle,
      statement: trimmedStatement,
      whenLabel: whenLabel?.trim().isEmpty ?? true ? null : whenLabel!.trim(),
      people: housePresence(people: people, sessionName: sessionName),
      status: commit ? IntentionStatus.committed : IntentionStatus.brewing,
      createdAt: DateTime.now(),
    );
    intentions = [intention, ...intentions];
    focusedPurposeId = purposeId;
    await _persistIntentions();
  }

  Future<void> commitIntention(String id) async {
    intentions = [
      for (final intention in intentions)
        if (intention.id == id && intention.status == IntentionStatus.brewing)
          intention.copyWith(status: IntentionStatus.committed)
        else
          intention,
    ];
    await _persistIntentions();
  }

  Future<void> cycleStatus(String id) async {
    intentions = [
      for (final intention in intentions)
        if (intention.id == id)
          intention.copyWith(status: intention.status.next)
        else
          intention,
    ];
    await _persistIntentions();
  }

  Future<void> removeIntention(String id) async {
    intentions = intentions.where((item) => item.id != id).toList();
    await _persistIntentions();
  }

  Future<void> loadSamples() async {
    final now = DateTime.now();
    purposes = samplePurposes(now: now);
    intentions = sampleIntentions(now: now, sessionName: sessionName);
    focusedPurposeId = purposes.first.id;
    await _persistPurposes();
    await _persistIntentions();
  }

  Purpose? purposeById(String id) {
    for (final purpose in purposes) {
      if (purpose.id == id) return purpose;
    }
    return null;
  }

  Intention? intentionById(String id) {
    for (final intention in intentions) {
      if (intention.id == id) return intention;
    }
    return null;
  }

  List<Intention> intentionsFor(String purposeId) {
    return intentions.where((item) => item.purposeId == purposeId).toList();
  }

  Future<void> _scrubPresence({required bool persist}) async {
    var changed = false;
    final cleaned = <Intention>[];
    for (final intention in intentions) {
      final people = housePresence(
        people: intention.people,
        sessionName: sessionName,
      );
      if (listEquals(people, intention.people)) {
        cleaned.add(intention);
      } else {
        changed = true;
        cleaned.add(intention.copyWith(people: people));
      }
    }
    if (!changed) return;
    intentions = cleaned;
    if (persist) await _persistIntentions();
  }

  Future<void> _persistPurposes() async {
    await store.write(
      purposesKey,
      jsonEncode(purposes.map((p) => p.toJson()).toList()),
    );
    notifyListeners();
  }

  Future<void> _persistIntentions() async {
    await store.write(
      intentionsKey,
      jsonEncode(intentions.map((i) => i.toJson()).toList()),
    );
    notifyListeners();
  }

  String _id(String prefix) {
    final n = _random.nextInt(1 << 32).toRadixString(16);
    return '$prefix-$n';
  }
}
