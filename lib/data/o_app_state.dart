import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/action_intent.dart';
import '../models/session.dart';
import 'o_companion.dart';
import 'o_store.dart';

const sessionKey = 'o.session';
const actionsKey = 'o.actions';

class OAppState extends ChangeNotifier {
  OAppState({required this.store, required this.companion, Random? random})
    : _random = random ?? Random();

  final OStore store;
  final OCompanion companion;
  final Random _random;

  bool ready = false;
  LocalSession? session;
  List<ActionIntent> actions = const [];

  Future<void> hydrate() async {
    final rawSession = await store.read(sessionKey);
    final rawActions = await store.read(actionsKey);
    if (rawSession != null) {
      session = LocalSession.fromJson(
        jsonDecode(rawSession) as Map<String, dynamic>,
      );
    }
    if (rawActions != null) {
      final list = jsonDecode(rawActions) as List<dynamic>;
      actions = list
          .map((row) => ActionIntent.fromJson(row as Map<String, dynamic>))
          .toList();
    }
    ready = true;
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
    notifyListeners();
  }

  Future<void> leave() async {
    session = null;
    await store.delete(sessionKey);
    notifyListeners();
  }

  Future<void> addAction({
    required String title,
    required String intent,
    String? whenLabel,
    List<String> people = const [],
  }) async {
    final trimmedTitle = title.trim();
    final trimmedIntent = intent.trim();
    if (trimmedTitle.isEmpty || trimmedIntent.isEmpty) {
      throw ArgumentError('An action needs a title and an intent.');
    }
    final you = session?.displayName ?? 'You';
    final named = [
      you,
      ...people.map((p) => p.trim()).where((p) => p.isNotEmpty && p != you),
    ];
    final action = ActionIntent(
      id: _id('act'),
      title: trimmedTitle,
      intent: trimmedIntent,
      whenLabel: whenLabel?.trim().isEmpty ?? true ? null : whenLabel!.trim(),
      people: named,
      status: ActionStatus.brewing,
      createdAt: DateTime.now(),
    );
    actions = [action, ...actions];
    await _persistActions();
  }

  Future<void> cycleStatus(String id) async {
    actions = [
      for (final action in actions)
        if (action.id == id)
          action.copyWith(status: action.status.next)
        else
          action,
    ];
    await _persistActions();
  }

  Future<void> removeAction(String id) async {
    actions = actions.where((action) => action.id != id).toList();
    await _persistActions();
  }

  Future<void> loadSamples() async {
    actions = sampleActions(now: DateTime.now());
    await _persistActions();
  }

  ActionIntent? byId(String id) {
    for (final action in actions) {
      if (action.id == id) return action;
    }
    return null;
  }

  Future<void> _persistActions() async {
    await store.write(
      actionsKey,
      jsonEncode(actions.map((a) => a.toJson()).toList()),
    );
    notifyListeners();
  }

  String _id(String prefix) {
    final n = _random.nextInt(1 << 32).toRadixString(16);
    return '$prefix-$n';
  }
}
