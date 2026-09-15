import 'dart:math';

import 'package:darc_o/app.dart';
import 'package:darc_o/data/o_app_state.dart';
import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/data/o_store.dart';
import 'package:darc_o/theme/o_theme.dart';
import 'package:darc_o/widgets/commit_button.dart';
import 'package:darc_o/widgets/purpose_stage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Dennis proof: gold Commit `#c9a227` on **Purpose-stage** home.
///
/// Commit lives *inside* the expanded Purpose — not on the old chip-strip
/// home. Ahem replaces glyphs in goldens. The pill colour is the proof.
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

  Finder commitInsidePurposeStage(String label) {
    return find.descendant(
      of: find.byKey(const Key('purpose-stage')),
      matching: find.widgetWithText(CommitButton, label),
    );
  }

  testWidgets(
    'Purpose-stage home Commit an intention is gold #c9a227, not forest green',
    (tester) async {
      await phoneSurface(tester);
      final state = OAppState(
        store: MemoryOStore(),
        companion: const StubOCompanion(),
        random: Random(3),
      );
      await state.hydrate();
      await state.enterLocal(displayName: 'Joshua');
      await state.addPurpose(
        title: 'Get outside this week',
        why: 'Leave the house.',
      );

      await tester.pumpWidget(
        KeyedSubtree(
          key: const Key('purpose-stage-commit-gold-proof'),
          child: OApp(state: state),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PurposeStage), findsOneWidget);
      expect(find.byKey(const Key('purpose-stage')), findsOneWidget);
      expect(find.text('PURPOSE'), findsOneWidget);
      expect(find.text('Get outside this week'), findsOneWidget);
      expect(find.text('Intention follows'), findsOneWidget);
      expect(find.text('New Purpose'), findsWidgets);
      expect(find.byType(ChoiceChip), findsNothing);
      expect(find.text('The stage is yours'), findsNothing);
      expect(find.text('Sam'), findsNothing);

      expect(commitInsidePurposeStage('Commit an intention'), findsOneWidget);

      final material = tester.widget<Material>(
        find.descendant(
          of: commitInsidePurposeStage('Commit an intention'),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, OColors.commit);
      expect(material.color, const Color(0xFFC9A227));
      expect(material.color, isNot(OColors.intention));
      expect(material.color, isNot(const Color(0xFF2F6F5E)));

      await expectLater(
        find.byKey(const Key('purpose-stage-commit-gold-proof')),
        matchesGoldenFile('goldens/purpose_stage_home_commit.png'),
      );
    },
  );

  testWidgets('gate Enter ō locally is the same gold #c9a227', (tester) async {
    await phoneSurface(tester);
    final state = OAppState(
      store: MemoryOStore(),
      companion: const StubOCompanion(),
      random: Random(3),
    );
    await state.hydrate();

    await tester.pumpWidget(
      KeyedSubtree(
        key: const Key('gate-enter-gold-proof'),
        child: OApp(state: state),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Enter ō locally'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Enter ō locally'),
    );
    final bg = button.style?.backgroundColor?.resolve({});
    expect(bg, OColors.commit);
    expect(bg, const Color(0xFFC9A227));

    await expectLater(
      find.byKey(const Key('gate-enter-gold-proof')),
      matchesGoldenFile('goldens/gate_enter_o_locally.png'),
    );
  });

  testWidgets('Commit an intention close-up is gold threshold', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 120));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: buildOTheme(),
        home: const Scaffold(
          backgroundColor: OColors.fieldAir,
          body: Padding(
            padding: EdgeInsets.all(20),
            child: RepaintBoundary(
              key: Key('commit-closeup'),
              child: CommitButton(
                label: 'Commit an intention',
                onPressed: _noop,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(CommitButton),
        matching: find.byType(Material),
      ),
    );
    expect(material.color, const Color(0xFFC9A227));

    await expectLater(
      find.byKey(const Key('commit-closeup')),
      matchesGoldenFile('goldens/commit_an_intention_closeup.png'),
    );
  });
}

void _noop() {}
