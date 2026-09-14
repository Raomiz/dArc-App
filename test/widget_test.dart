import 'dart:math';

import 'package:darc_o/app.dart';
import 'package:darc_o/data/o_app_state.dart';
import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/data/o_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('gate, empty home, sample action, stub ō panel', (tester) async {
    final state = OAppState(
      store: MemoryOStore(),
      companion: const StubOCompanion(),
      random: Random(3),
    );
    await state.hydrate();

    await tester.pumpWidget(OApp(state: state));
    expect(find.text('Act with others.'), findsOneWidget);
    expect(find.textContaining('Placeholder session'), findsOneWidget);
    expect(find.textContaining('atlas'), findsNothing);

    await tester.enterText(
      find.byType(TextField),
      'Joshua',
    );
    await tester.tap(find.text('Enter ō locally'));
    await tester.pumpAndSettle();

    expect(find.text('Nothing in motion yet'), findsOneWidget);
    expect(
      find.textContaining('ō will help you coordinate'),
      findsOneWidget,
    );

    await tester.tap(find.text('Load sample actions'));
    await tester.pumpAndSettle();
    expect(find.text('Evening walk'), findsOneWidget);
    expect(find.text('Saturday potluck'), findsOneWidget);

    await tester.tap(find.text('Evening walk'));
    await tester.pumpAndSettle();
    expect(find.text('Coordinate with ō'), findsOneWidget);

    await tester.tap(find.text('Coordinate with ō'));
    await tester.pumpAndSettle();
    expect(find.text('STUB'), findsOneWidget);
    expect(find.textContaining('No live model'), findsOneWidget);
    expect(find.textContaining('Stub ·'), findsWidgets);
  });
}
