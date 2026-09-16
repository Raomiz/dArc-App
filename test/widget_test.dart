import 'dart:math';

import 'package:darc_o/app.dart';
import 'package:darc_o/data/o_app_state.dart';
import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/data/o_store.dart';
import 'package:darc_o/nav/o_paces.dart';
import 'package:darc_o/screens/intention_detail_screen.dart';
import 'package:darc_o/theme/o_theme.dart';
import 'package:darc_o/widgets/commit_button.dart';
import 'package:darc_o/widgets/o_navigator.dart';
import 'package:darc_o/widgets/purpose_stage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home lands on New Purpose; Intention follows inside the stage', (
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
    expect(find.textContaining('ō coordinating:'), findsOneWidget);
    expect(find.textContaining('On this device'), findsOneWidget);
    expect(find.textContaining('Placeholder session'), findsNothing);
    expect(find.textContaining('atlas'), findsNothing);
    expect(find.text('Rin'), findsNothing);
    expect(find.text('Ade'), findsNothing);

    await tester.enterText(find.byType(TextField), 'Joshua');
    await tester.tap(find.text('Enter ō locally'));
    await tester.pumpAndSettle();

    expect(find.text('New Purpose'), findsOneWidget);
    expect(find.byKey(const Key('new-purpose-fab')), findsOneWidget);
    expect(find.byKey(const Key('empty-field')), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'New Purpose'), findsNothing);
    expect(find.textContaining('north star'), findsNothing);
    expect(find.text('The field is open'), findsNothing);
    expect(find.textContaining('plan'), findsNothing);
    expect(find.text('Sam'), findsNothing);
    expect(find.byType(ONavigatorButton), findsOneWidget);
    expect(find.text('Rin'), findsNothing);

    await tester.tap(find.byType(ONavigatorButton));
    await tester.pumpAndSettle();
    expect(find.text('In-app navigator'), findsOneWidget);
    expect(find.textContaining('I am ō'), findsOneWidget);
    expect(find.textContaining('not a game creature'), findsOneWidget);
    expect(find.textContaining('Grok'), findsOneWidget);
    expect(find.textContaining('wisp'), findsWidgets);
    expect(find.text('Sam'), findsNothing);
    Navigator.of(tester.element(find.text('In-app navigator'))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('new-purpose-fab')));
    await tester.pumpAndSettle();
    final purposeFields = find.byType(TextField);
    await tester.enterText(purposeFields.at(0), 'Get outside this week');
    await tester.enterText(
      purposeFields.at(1),
      'Leave the house. Not a thread — a walk.',
    );
    await tester.tap(find.text('Hold this purpose'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('purpose-stage')), findsOneWidget);
    expect(find.byType(PurposeStage), findsOneWidget);
    expect(find.text('PURPOSE'), findsOneWidget);
    expect(find.text('Get outside this week'), findsOneWidget);
    expect(find.text('Intentions'), findsOneWidget);
    expect(find.text('Brewing'), findsOneWidget);
    expect(find.text('People'), findsOneWidget);
    expect(find.text('Evidence'), findsOneWidget);
    expect(find.text('Intention follows'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
    expect(find.byType(PurposeOrbit), findsNothing);
    expect(find.text('The stage is yours'), findsNothing);
    final commitCta = tester.widget<Material>(
      find.descendant(
        of: find.descendant(
          of: find.byKey(const Key('purpose-stage')),
          matching: find.widgetWithText(CommitButton, 'Commit an intention'),
        ),
        matching: find.byType(Material),
      ),
    );
    expect(commitCta.color, OColors.commit);
    expect(commitCta.color, isNot(OColors.intention));
    expect(find.text('New Purpose'), findsOneWidget);
    expect(find.byKey(const Key('purpose-stage-bloom')), findsOneWidget);
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
    await tester.ensureVisible(find.text('Commit this intention'));
    await tester.tap(find.text('Commit this intention'));
    await tester.pumpAndSettle();

    expect(find.text('Evening walk'), findsOneWidget);
    expect(find.textContaining('Committed'), findsWidgets);
    expect(find.text('Joshua'), findsWidgets);
    expect(find.text('Coordinate with ō'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('purpose-stage')),
        matching: find.text('Coordinate with ō'),
      ),
      findsOneWidget,
    );
    expect(find.byType(IntentionMorePanel), findsNothing);
    expect(find.text('You · Rin'), findsNothing);
    expect(find.text('Rin'), findsNothing);
    expect(find.text('Ade'), findsNothing);
    expect(maxPacesFromStage, 3);

    await tester.tap(find.text('Coordinate with ō'));
    await tester.pumpAndSettle();
    expect(find.text('STUB'), findsOneWidget);
    expect(find.textContaining('Grok'), findsWidgets);
    expect(find.textContaining('Stub ·'), findsWidgets);
    expect(find.textContaining('plan'), findsNothing);
    expect(find.textContaining('OpenAI'), findsOneWidget);
    expect(find.text('Rin'), findsNothing);
  });

  testWidgets('held intention commits from inside the expanded Purpose', (
    tester,
  ) async {
    final state = OAppState(
      store: MemoryOStore(),
      companion: const StubOCompanion(),
      random: Random(5),
    );
    await state.hydrate();
    await state.enterLocal(displayName: 'Joshua');
    await state.addPurpose(
      title: 'Get outside this week',
      why: 'Leave the house.',
    );
    await state.addIntention(
      purposeId: state.purposes.first.id,
      title: 'Evening walk',
      statement: 'Leave the house.',
    );

    await tester.pumpWidget(OApp(state: state));
    await tester.pumpAndSettle();

    expect(find.byType(PurposeStage), findsOneWidget);
    expect(find.textContaining('Brewing'), findsWidgets);
    expect(find.text('Get outside this week'), findsOneWidget);
    expect(find.text('PURPOSE'), findsOneWidget);
    expect(find.text('New Purpose'), findsOneWidget);
    expect(find.text('Commit this intention'), findsOneWidget);
    expect(find.text('Coordinate with ō'), findsOneWidget);
    expect(find.byType(ONavigatorButton), findsOneWidget);
    expect(find.text('Sam'), findsNothing);
    expect(find.byType(ChoiceChip), findsNothing);

    final gold = tester.widget<Material>(
      find.descendant(
        of: find.descendant(
          of: find.byKey(const Key('purpose-stage')),
          matching: find.widgetWithText(
            CommitButton,
            'Commit this intention',
          ),
        ),
        matching: find.byType(Material),
      ),
    );
    expect(gold.color, OColors.commit);

    await tester.tap(find.text('Commit this intention'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Committed'), findsWidgets);
    expect(find.byType(IntentionMorePanel), findsNothing);
    expect(find.text('Rin'), findsNothing);
  });

  testWidgets('satellites switch Purpose; manners stay inside the stage', (
    tester,
  ) async {
    final state = OAppState(
      store: MemoryOStore(),
      companion: const StubOCompanion(),
      random: Random(9),
    );
    await state.hydrate();
    await state.enterLocal(displayName: 'Joshua');
    await state.addPurpose(
      title: 'Get outside this week',
      why: 'Leave the house.',
    );
    final outsideId = state.purposes.first.id;
    await state.addIntention(
      purposeId: outsideId,
      title: 'Evening walk',
      statement: 'Leave the house.',
    );
    await state.addPurpose(
      title: 'A table this week',
      why: 'A table, a time, dishes that actually arrive.',
    );

    await tester.pumpWidget(OApp(state: state));
    await tester.pumpAndSettle();

    expect(find.byType(PurposeOrbit), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
    expect(find.text('A table this week'), findsWidgets);
    expect(find.text('Intention follows'), findsOneWidget);
    expect(find.text('Evening walk'), findsNothing);

    await tester.tap(find.byKey(Key('purpose-satellite-$outsideId')));
    await tester.pumpAndSettle();

    expect(find.text('Evening walk'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('purpose-stage')),
        matching: find.text('Evening walk'),
      ),
      findsOneWidget,
    );
    expect(find.text('Commit this intention'), findsOneWidget);

    await tester.tap(find.byKey(const Key('purpose-manner-people')));
    await tester.pumpAndSettle();
    expect(
      find.text('People named on this purpose. No invented cast.'),
      findsOneWidget,
    );
    expect(find.text('Joshua'), findsWidgets);
    expect(find.text('Nobody else is here yet.'), findsNothing);
    expect(find.text('Rin'), findsNothing);
    expect(find.text('Evening walk'), findsNothing);

    await tester.tap(find.byKey(const Key('purpose-manner-evidence')));
    await tester.pumpAndSettle();
    expect(
      find.text('No evidence yet. Commit an intention and it will hold here.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('purpose-manner-brewing')));
    await tester.pumpAndSettle();
    expect(find.text('Evening walk'), findsOneWidget);
    expect(find.text('Commit this intention'), findsOneWidget);

    await tester.tap(find.text('Commit this intention'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('purpose-manner-evidence')));
    await tester.pumpAndSettle();
    expect(find.text('Evening walk'), findsOneWidget);
    expect(find.textContaining('Committed'), findsWidgets);
    expect(find.textContaining('plan'), findsNothing);
    expect(find.text('Sam'), findsNothing);
  });

  testWidgets('expanded Purpose at phone width keeps Commit gold with no overflow', (
    tester,
  ) async {
    final state = OAppState(
      store: MemoryOStore(),
      companion: const StubOCompanion(),
      random: Random(11),
    );
    await state.hydrate();
    await state.enterLocal(displayName: 'Joshua');
    await state.addPurpose(
      title: 'Get outside this week',
      why: 'Leave the house. Not a thread — a walk.',
    );
    await state.addIntention(
      purposeId: state.purposes.first.id,
      title: 'Evening walk',
      statement: 'Leave the house. Not a chat thread — a walk.',
      whenLabel: 'Tonight after 18:00',
    );
    await state.addPurpose(
      title: 'A table this week',
      why: 'A table, a time, dishes that actually arrive.',
    );
    state.focusPurpose(state.purposes.last.id);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(OApp(state: state));
    await tester.pumpAndSettle();

    expect(find.byType(PurposeStage), findsOneWidget);
    expect(find.byType(PurposeOrbit), findsOneWidget);
    expect(find.text('Commit this intention'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final gold = tester.widget<Material>(
      find.descendant(
        of: find.widgetWithText(CommitButton, 'Commit this intention'),
        matching: find.byType(Material),
      ),
    );
    expect(gold.color, OColors.commit);
  });
}
