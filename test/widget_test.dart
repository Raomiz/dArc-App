import 'dart:math';

import 'package:darc_o/app.dart';
import 'package:darc_o/data/o_app_state.dart';
import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/data/o_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('gate, purpose, intention, stub ō, Sam navigator', (tester) async {
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

    expect(find.text('No purpose yet'), findsOneWidget);
    expect(find.textContaining('ō coordinates'), findsOneWidget);
    expect(find.text('Sam'), findsOneWidget);

    await tester.tap(find.text('Sam'));
    await tester.pumpAndSettle();
    expect(find.text('In-app navigator'), findsOneWidget);
    expect(find.textContaining('not a game creature'), findsOneWidget);
    expect(find.textContaining('Grok'), findsOneWidget);
    Navigator.of(tester.element(find.text('In-app navigator'))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Load sample purposes'));
    await tester.pumpAndSettle();
    expect(find.text('Get outside this week'), findsOneWidget);
    expect(find.text('Feed people'), findsOneWidget);

    await tester.tap(find.text('Get outside this week'));
    await tester.pumpAndSettle();
    expect(find.text('Evening walk'), findsOneWidget);
    expect(find.text('You · Rin'), findsOneWidget);

    await tester.tap(find.text('Evening walk'));
    await tester.pumpAndSettle();
    expect(find.text('Commit this intention'), findsOneWidget);
    expect(find.text('Coordinate with ō'), findsOneWidget);

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
  });
}
