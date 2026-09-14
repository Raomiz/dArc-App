import 'dart:math';

import 'package:darc_o/data/o_app_state.dart';
import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/data/o_store.dart';
import 'package:darc_o/models/action_intent.dart';
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
    expect(state.actions, isEmpty);
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

  test('addAction requires title and intent', () async {
    final state = build();
    await state.hydrate();
    await state.enterLocal(displayName: 'You');
    expect(
      () => state.addAction(title: ' ', intent: 'go'),
      throwsArgumentError,
    );
  });

  test('samples and status cycle stay on device', () async {
    final state = build();
    await state.hydrate();
    await state.loadSamples();
    expect(state.actions, hasLength(2));
    expect(state.actions.first.title, 'Evening walk');
    final id = state.actions.first.id;
    expect(state.actions.first.status, ActionStatus.brewing);
    await state.cycleStatus(id);
    expect(state.byId(id)!.status, ActionStatus.inMotion);
  });
}
