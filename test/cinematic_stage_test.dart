import 'dart:math';
import 'dart:ui';

import 'package:darc_o/app.dart';
import 'package:darc_o/data/o_app_state.dart';
import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/data/o_store.dart';
import 'package:darc_o/theme/o_theme.dart';
import 'package:darc_o/widgets/commit_button.dart';
import 'package:darc_o/widgets/field_backdrop.dart';
import 'package:darc_o/widgets/intention_card.dart';
import 'package:darc_o/widgets/purpose_stage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const phone = Size(390, 844);

  Future<void> phoneSurface(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(phone);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.view.physicalSize = phone;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<OAppState> signedIn() async {
    final state = OAppState(
      store: MemoryOStore(),
      companion: const StubOCompanion(),
      random: Random(3),
    );
    await state.hydrate();
    await state.enterLocal(displayName: 'Joshua');
    return state;
  }

  testWidgets('first-open empty field is wash + one New Purpose FAB', (
    tester,
  ) async {
    await phoneSurface(tester);
    final state = await signedIn();
    await tester.pumpWidget(OApp(state: state));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('empty-field')), findsOneWidget);
    expect(find.byKey(const Key('new-purpose-fab')), findsOneWidget);
    expect(find.text('New Purpose'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'New Purpose'), findsNothing);
    expect(find.byType(PurposeStage), findsNothing);
    expect(find.textContaining('north star'), findsNothing);
    expect(find.text('Hello, Joshua'), findsNothing);
    expect(find.text('Sam'), findsNothing);
    expect(find.textContaining('plan'), findsNothing);
    expect(find.byType(FieldBackdrop), findsOneWidget);
  });

  testWidgets('expanded Purpose is a bloom stage, not a white sheet stack', (
    tester,
  ) async {
    await phoneSurface(tester);
    final state = await signedIn();
    await state.addPurpose(
      title: 'Get outside this week',
      why: 'Leave the house. Not a thread — a walk.',
    );
    final outsideId = state.purposes.first.id;
    await state.addPurpose(
      title: 'A table this week',
      why: 'A table, a time, dishes that actually arrive.',
    );
    state.focusPurpose(outsideId);
    await tester.pumpWidget(OApp(state: state));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('purpose-stage-bloom')), findsOneWidget);
    expect(find.byType(PurposeOrbit), findsOneWidget);
    expect(find.byKey(const Key('purpose-orbit-dim')), findsOneWidget);

    final bloom = tester.widget<DecoratedBox>(
      find.byKey(const Key('purpose-stage-bloom')),
    );
    final box = bloom.decoration as BoxDecoration;
    expect(box.color, isNull);
    expect(box.border, isNull);
    expect(box.gradient, isNotNull);
    expect(
      (box.gradient! as RadialGradient).colors.first,
      OType.purposeBloom,
    );

    final title = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const Key('purpose-stage')),
        matching: find.text('Get outside this week'),
      ),
    );
    expect(title.style?.fontSize, 23);
    expect(title.style?.color, OColors.purposeDeep);
    expect(title.style?.fontWeight, FontWeight.w600);

    expect(find.byType(ImageFiltered), findsWidgets);
    final blur = tester.widget<ImageFiltered>(find.byType(ImageFiltered).first);
    expect(blur.imageFilter, isA<ImageFilter>());
  });

  testWidgets('Intention frost holds real type and a quiet Coordinate', (
    tester,
  ) async {
    await phoneSurface(tester);
    final state = await signedIn();
    await state.addPurpose(
      title: 'Get outside this week',
      why: 'Leave the house.',
    );
    await state.addIntention(
      purposeId: state.purposes.first.id,
      title: 'Evening walk',
      statement: 'Leave the house. Not a chat thread — a walk.',
      whenLabel: 'Tonight after 18:00',
    );
    await tester.pumpWidget(OApp(state: state));
    await tester.pumpAndSettle();

    expect(find.byType(IntentionCard), findsOneWidget);
    final intentionTitle = tester.widget<Text>(find.text('Evening walk'));
    expect(intentionTitle.style?.fontSize, 16.5);

    expect(find.textContaining('Brewing'), findsWidgets);
    expect(find.text('BREWING'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Coordinate with ō'), findsNothing);
    expect(find.text('Coordinate with ō'), findsOneWidget);
    expect(find.text('New Purpose'), findsOneWidget);
    expect(find.text('Sam'), findsNothing);

    final gold = tester.widget<Material>(
      find.descendant(
        of: find.byType(CommitButton),
        matching: find.byType(Material),
      ),
    );
    expect(gold.color, OColors.commit);
  });
}
