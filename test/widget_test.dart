import 'dart:math';

import 'package:darc_o/app.dart';
import 'package:darc_o/data/o_app_state.dart';
import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/data/o_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('gate, purpose north star, intention stage, stub ō, Sam', (
    tester,
  ) async {
    final state = OAppState(
      store: MemoryOStore(),
      companion: const StubOCompanion(),
      random: Random(3),
    );
    await state.hydrate();

    await tester.pumpWidget(OApp(state: state));
    expect(find.text('Act with others.'), findsOneWidget);
    expect(find.textContaining('On this device'), findsOneWidget);
    expect(find.textContaining('Placeholder session'), findsNothing);
    expect(find.textContaining('atlas'), findsNothing);
    expect(find.text('Rin'), findsNothing);
    expect(find.text('Ade'), findsNothing);

    await tester.enterText(find.byType(TextField), 'Joshua');
    await tester.tap(find.text('Enter ō locally'));
    await tester.pumpAndSettle();

    expect(find.text('The field is open'), findsOneWidget);
    expect(find.textContaining('north star'), findsOneWidget);
    expect(find.textContaining('plan'), findsNothing);
    expect(find.text('Sam'), findsOneWidget);
    expect(find.text('Rin'), findsNothing);

    await tester.tap(find.text('Sam'));
    await tester.pumpAndSettle();
    expect(find.text('In-app navigator'), findsOneWidget);
    expect(find.textContaining('not a game creature'), findsOneWidget);
    expect(find.textContaining('Grok'), findsOneWidget);
    expect(find.textContaining('wisp'), findsWidgets);
    Navigator.of(tester.element(find.text('In-app navigator'))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Name a purpose').first);
    await tester.pumpAndSettle();
    final purposeFields = find.byType(TextField);
    await tester.enterText(purposeFields.at(0), 'Get outside this week');
    await tester.enterText(
      purposeFields.at(1),
      'Leave the house. Not a thread — a walk.',
    );
    await tester.tap(find.text('Hold this purpose'));
    await tester.pumpAndSettle();

    expect(find.text('PURPOSE'), findsOneWidget);
    expect(find.text('Get outside this week'), findsOneWidget);
    expect(find.text('INTENTIONS'), findsOneWidget);
    expect(find.text('The stage is yours'), findsOneWidget);
    expect(find.text('Load sample purposes'), findsNothing);
    expect(find.text('Rin'), findsNothing);
    expect(find.text('Ade'), findsNothing);

    await tester.tap(find.text('Commit an intention').first);
    await tester.pumpAndSettle();
    final intentionFields = find.byType(TextField);
    await tester.enterText(intentionFields.at(0), 'Evening walk');
    await tester.enterText(
      intentionFields.at(1),
      'Leave the house. Not a chat thread — a walk.',
    );
    await tester.tap(find.text('Hold this intention'));
    await tester.pumpAndSettle();

    expect(find.text('Evening walk'), findsOneWidget);
    expect(find.text('Joshua'), findsWidgets);
    expect(find.text('You · Rin'), findsNothing);
    expect(find.text('Rin'), findsNothing);
    expect(find.text('Ade'), findsNothing);

    await tester.tap(find.text('Evening walk'));
    await tester.pumpAndSettle();
    expect(find.text('Commit this intention'), findsOneWidget);
    expect(find.text('Coordinate with ō'), findsOneWidget);
    expect(find.text('Joshua'), findsWidgets);

    await tester.tap(find.text('Commit this intention'));
    await tester.pumpAndSettle();
    expect(find.text('COMMITTED'), findsOneWidget);

    await tester.tap(find.text('Coordinate with ō'));
    await tester.pumpAndSettle();
    expect(find.text('STUB'), findsOneWidget);
    expect(find.textContaining('Grok'), findsWidgets);
    expect(find.textContaining('Stub ·'), findsWidgets);
    expect(find.textContaining('plan'), findsNothing);
    expect(find.textContaining('OpenAI'), findsOneWidget);
    expect(find.text('Rin'), findsNothing);
  });
}
