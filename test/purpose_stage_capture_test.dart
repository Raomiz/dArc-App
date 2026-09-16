import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:darc_o/app.dart';
import 'package:darc_o/data/o_app_state.dart';
import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/data/o_store.dart';
import 'package:darc_o/theme/o_theme.dart';
import 'package:darc_o/widgets/commit_button.dart';
import 'package:darc_o/widgets/purpose_stage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Agent captures for Desigu cinematic proofs — real Inter strings.
///
/// Default `flutter test` skips this so the suite never hangs on toImage.
/// Generate with:
/// `flutter test --dart-define=CAPTURE=true test/purpose_stage_capture_test.dart`
const capture = bool.fromEnvironment('CAPTURE');

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

  Future<void> writePng({
    required WidgetTester tester,
    required Key key,
    required String name,
  }) async {
    final out = Directory('docs/screenshots');
    out.createSync(recursive: true);
    await tester.pump();
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(key),
    );
    final image = await tester.runAsync(
      () => boundary.toImage(pixelRatio: 1.5),
    );
    final bytes = await tester.runAsync(
      () => image!.toByteData(format: ui.ImageByteFormat.png),
    );
    File('${out.path}/$name').writeAsBytesSync(bytes!.buffer.asUint8List());
  }

  Future<OAppState> baseState() async {
    final state = OAppState(
      store: MemoryOStore(),
      companion: const StubOCompanion(),
      random: Random(3),
    );
    await state.hydrate();
    return state;
  }

  testWidgets('capture empty field after local-name gate', (tester) async {
    final state = await baseState();
    await state.enterLocal(displayName: 'Joshua');
    await phoneSurface(tester);
    await tester.pumpWidget(
      RepaintBoundary(
        key: const Key('empty-field-capture'),
        child: OApp(state: state),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('empty-field')), findsOneWidget);
    expect(find.text('New Purpose'), findsOneWidget);
    await writePng(
      tester: tester,
      key: const Key('empty-field-capture'),
      name: 'empty_field_new_purpose.png',
    );
  }, skip: !capture);

  testWidgets('capture expanded Purpose as stage with Commit gold', (
    tester,
  ) async {
    final state = await baseState();
    await state.enterLocal(displayName: 'Joshua');
    await state.addPurpose(
      title: 'Get outside this week',
      why: 'Leave the house. Not a thread — a walk.',
    );
    final outsideId = state.purposes.first.id;
    await state.addIntention(
      purposeId: outsideId,
      title: 'Evening walk',
      statement: 'Leave the house. Not a chat thread — a walk.',
      whenLabel: 'Tonight after 18:00',
    );
    await state.addPurpose(
      title: 'A table this week',
      why: 'A table, a time, dishes that actually arrive.',
    );
    state.focusPurpose(outsideId);

    await phoneSurface(tester);
    await tester.pumpWidget(
      RepaintBoundary(
        key: const Key('purpose-stage-capture'),
        child: OApp(state: state),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PurposeStage), findsOneWidget);
    expect(find.byKey(const Key('purpose-stage-bloom')), findsOneWidget);
    expect(find.byType(PurposeOrbit), findsOneWidget);
    expect(find.text('Commit this intention'), findsOneWidget);
    expect(find.text('Get outside this week'), findsWidgets);
    expect(find.text('Evening walk'), findsOneWidget);
    final gold = tester.widget<Material>(
      find.descendant(
        of: find.byType(CommitButton),
        matching: find.byType(Material),
      ),
    );
    expect(gold.color, OColors.commit);

    await writePng(
      tester: tester,
      key: const Key('purpose-stage-capture'),
      name: 'expanded_purpose_commit_gold.png',
    );
  }, skip: !capture);

  testWidgets('capture full-phone Commit rest and soft press', (tester) async {
    final state = await baseState();
    await state.enterLocal(displayName: 'Joshua');
    await state.addPurpose(
      title: 'Get outside this week',
      why: 'Leave the house. Not a thread — a walk.',
    );
    final outsideId = state.purposes.first.id;
    await state.addIntention(
      purposeId: outsideId,
      title: 'Evening walk',
      statement: 'Leave the house. Not a chat thread — a walk.',
      whenLabel: 'Tonight after 18:00',
    );
    await state.addPurpose(
      title: 'A table this week',
      why: 'A table, a time, dishes that actually arrive.',
    );
    state.focusPurpose(outsideId);

    await phoneSurface(tester);
    await tester.pumpWidget(
      RepaintBoundary(
        key: const Key('commit-press-capture'),
        child: OApp(state: state),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Commit this intention'));
    final rest = tester.widget<Material>(
      find.descendant(
        of: find.byType(CommitButton),
        matching: find.byType(Material),
      ),
    );
    expect(rest.color, OColors.commit);

    await writePng(
      tester: tester,
      key: const Key('commit-press-capture'),
      name: 'commit_gold_rest.png',
    );

    final gesture = await tester.press(find.text('Commit this intention'));
    await tester.pump(OType.commitPress);
    final pressed = tester.widget<Material>(
      find.descendant(
        of: find.byType(CommitButton),
        matching: find.byType(Material),
      ),
    );
    expect(pressed.color, OColors.commitSoft);

    await writePng(
      tester: tester,
      key: const Key('commit-press-capture'),
      name: 'commit_gold_soft_press.png',
    );
    await gesture.up();
  }, skip: !capture);
}
