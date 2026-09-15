import 'dart:math';

import 'package:darc_o/data/o_app_state.dart';
import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/data/o_store.dart';
import 'package:darc_o/models/intention.dart';
import 'package:flutter_test/flutter_test.dart';

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

  test('samples, commit, and status stay on device', () async {
    final state = build();
    await state.hydrate();
    await state.loadSamples();
    expect(state.purposes, hasLength(2));
    expect(state.intentions, hasLength(2));
    expect(state.purposes.first.title, 'Get outside this week');
    expect(state.intentions.first.title, 'Evening walk');
    expect(
      state.intentions.expand((i) => i.people),
      isNot(contains('Sam')),
    );
    final id = state.intentions.first.id;
    expect(state.intentions.first.status, IntentionStatus.brewing);
    await state.commitIntention(id);
    expect(state.intentionById(id)!.status, IntentionStatus.committed);
    await state.cycleStatus(id);
    expect(state.intentionById(id)!.status, IntentionStatus.done);
  });
}
