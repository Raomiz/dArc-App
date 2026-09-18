import 'dart:convert';
import 'dart:math';

import 'package:darc_o/data/o_app_state.dart';
import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/data/o_store.dart';
import 'package:darc_o/models/intention.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  OAppState build() {
    return OAppState(
      store: MemoryOStore(),
      companion: const StubOCompanion(),
      random: Random(7),
    );
  }

  test('hydrate with empty store is ready and unsigned', () async {
    final state = build();
    await state.hydrate();
    expect(state.ready, isTrue);
    expect(state.session, isNull);
    expect(state.purposes, isEmpty);
    expect(state.intentions, isEmpty);
  });

  test('local session persists across hydrate', () async {
    final store = MemoryOStore();
    final first = OAppState(
      store: store,
      companion: const StubOCompanion(),
      random: Random(1),
    );
    await first.hydrate();
    await first.enterLocal(displayName: '  Joshua  ');
    expect(first.session!.displayName, 'Joshua');

    final second = OAppState(
      store: store,
      companion: const StubOCompanion(),
      random: Random(2),
    );
    await second.hydrate();
    expect(second.session!.displayName, 'Joshua');
  });

  test('purpose and intention require real words', () async {
    final state = build();
    await state.hydrate();
    await state.enterLocal(displayName: 'You');
    expect(
      () => state.addPurpose(title: ' ', why: 'go'),
      throwsArgumentError,
    );
    await state.addPurpose(title: 'Get outside', why: 'Walk with people.');
    expect(
      () => state.addIntention(
        purposeId: state.purposes.first.id,
        title: ' ',
        statement: 'go',
      ),
      throwsArgumentError,
    );
  });

  test('samples stay session-name only and never invent a cast', () async {
    final state = build();
    await state.hydrate();
    await state.enterLocal(displayName: 'Joshua');
    await state.loadSamples();
    expect(state.purposes, hasLength(2));
    expect(state.intentions, hasLength(2));
    expect(state.purposes.first.title, 'Get outside this week');
    expect(state.intentions.first.title, 'Evening walk');
    expect(state.focusedPurpose?.title, 'Get outside this week');
    final people = state.intentions.expand((i) => i.people).toList();
    expect(people.toSet(), {'Joshua'});
    expect(people, isNot(contains('Rin')));
    expect(people, isNot(contains('Ade')));
    expect(people, isNot(contains('Sam')));
    expect(people, isNot(contains('You')));
    final id = state.intentions.first.id;
    expect(state.intentions.first.status, IntentionStatus.brewing);
    await state.commitIntention(id);
    expect(state.intentionById(id)!.status, IntentionStatus.committed);
    await state.cycleStatus(id);
    expect(state.intentionById(id)!.status, IntentionStatus.done);
  });

  test('hydrate scrubs placeholder cast from stored intentions', () async {
    final now = DateTime.utc(2026, 9, 15).toIso8601String();
    final store = MemoryOStore({
      sessionKey: jsonEncode({
        'id': 'ses-1',
        'displayName': 'Joshua',
        'startedAt': now,
      }),
      purposesKey: jsonEncode([
        {
          'id': 'purpose-outside',
          'title': 'Get outside this week',
          'why': 'Leave the house.',
          'createdAt': now,
        },
      ]),
      intentionsKey: jsonEncode([
        {
          'id': 'sample-walk',
          'purposeId': 'purpose-outside',
          'title': 'Evening walk',
          'statement': 'Leave the house.',
          'whenLabel': 'Tonight',
          'people': ['You', 'Rin', 'Ade'],
          'status': 'brewing',
          'createdAt': now,
        },
      ]),
    });
    final state = OAppState(
      store: store,
      companion: const StubOCompanion(),
      random: Random(4),
    );
    await state.hydrate();
    expect(state.intentions.single.people, ['Joshua']);
    final stored = jsonDecode(await store.read(intentionsKey) as String) as List;
    expect((stored.first as Map)['people'], ['Joshua']);
  });

  test('typed names survive; placeholder names do not', () async {
    final state = build();
    await state.hydrate();
    await state.enterLocal(displayName: 'Joshua');
    await state.addPurpose(title: 'Get outside', why: 'Walk.');
    await state.addIntention(
      purposeId: state.purposes.first.id,
      title: 'Evening walk',
      statement: 'Leave the house.',
      people: const ['Rin', 'Maya', 'Ade', 'Joshua'],
    );
    expect(state.intentions.single.people, ['Joshua', 'Maya']);
  });

  test('Purpose → Intention → Commit survive hydrate on the same store', () async {
    final store = MemoryOStore();
    final first = OAppState(
      store: store,
      companion: const StubOCompanion(),
      random: Random(3),
    );
    await first.hydrate();
    await first.enterLocal(displayName: 'Joshua');
    await first.addPurpose(title: 'Get outside this week', why: 'Walk with people.');
    await first.addIntention(
      purposeId: first.purposes.first.id,
      title: 'Evening walk',
      statement: 'Leave the house.',
      commit: true,
    );

    final second = OAppState(
      store: store,
      companion: const StubOCompanion(),
      random: Random(4),
    );
    await second.hydrate();
    expect(second.session!.displayName, 'Joshua');
    expect(second.purposes.single.title, 'Get outside this week');
    expect(second.intentions.single.title, 'Evening walk');
    expect(second.intentions.single.status, IntentionStatus.committed);
    expect(second.focusedPurpose?.title, 'Get outside this week');
  });

  test('PrefsOStore cold start keeps name, Purpose, committed Intention', () async {
    SharedPreferences.setMockInitialValues({});
    final first = OAppState(
      store: PrefsOStore(),
      companion: const StubOCompanion(),
      random: Random(8),
    );
    await first.hydrate();
    await first.enterLocal(displayName: 'Joshua');
    await first.addPurpose(
      title: 'Get outside this week',
      why: 'Leave the house. Not a thread — a walk.',
    );
    await first.addIntention(
      purposeId: first.purposes.first.id,
      title: 'Evening walk',
      statement: 'Leave the house.',
      commit: true,
    );

    final cold = OAppState(
      store: PrefsOStore(),
      companion: const StubOCompanion(),
      random: Random(9),
    );
    await cold.hydrate();
    expect(cold.session!.displayName, 'Joshua');
    expect(cold.purposes.single.title, 'Get outside this week');
    expect(cold.intentions.single.title, 'Evening walk');
    expect(cold.intentions.single.status, IntentionStatus.committed);
    expect(cold.focusedPurpose?.id, first.purposes.single.id);
  });

  test('focused Purpose survives reload when it is not the newest', () async {
    SharedPreferences.setMockInitialValues({});
    final first = OAppState(
      store: PrefsOStore(),
      companion: const StubOCompanion(),
      random: Random(11),
    );
    await first.hydrate();
    await first.enterLocal(displayName: 'Joshua');
    await first.addPurpose(title: 'Get outside this week', why: 'Walk.');
    final outsideId = first.purposes.first.id;
    await first.addPurpose(title: 'A table this week', why: 'A table.');
    await first.focusPurpose(outsideId);
    expect(first.focusedPurpose?.title, 'Get outside this week');

    final cold = OAppState(
      store: PrefsOStore(),
      companion: const StubOCompanion(),
      random: Random(12),
    );
    await cold.hydrate();
    expect(cold.focusedPurpose?.id, outsideId);
    expect(cold.focusedPurpose?.title, 'Get outside this week');
    expect(cold.purposes, hasLength(2));
  });

  test('addIntention can cross the Commit threshold in one write', () async {
    final state = build();
    await state.hydrate();
    await state.enterLocal(displayName: 'Joshua');
    await state.addPurpose(title: 'Get outside', why: 'Walk.');
    await state.addIntention(
      purposeId: state.purposes.first.id,
      title: 'Evening walk',
      statement: 'Leave the house.',
      commit: true,
    );
    expect(state.intentions.single.status, IntentionStatus.committed);
    expect(state.intentions.single.people, ['Joshua']);
  });
}
