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

/// Agent capture for Dennis PASS — expanded Purpose with gold Commit.
///
/// Default `flutter test` skips this so the suite never hangs on toImage.
/// Generate with:
/// `flutter test --dart-define=CAPTURE=true test/purpose_stage_capture_test.dart`
const capture = bool.fromEnvironment('CAPTURE');

void main() {
  testWidgets('capture expanded Purpose with Commit gold', (tester) async {
    final out = Directory('docs/screenshots');
    out.createSync(recursive: true);

    final state = OAppState(
      store: MemoryOStore(),
      companion: const StubOCompanion(),
      random: Random(3),
    );
    await state.hydrate();
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

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      RepaintBoundary(
        key: const Key('purpose-stage-capture'),
        child: OApp(state: state),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PurposeStage), findsOneWidget);
    expect(find.byType(PurposeOrbit), findsOneWidget);
    expect(find.text('Commit this intention'), findsOneWidget);
    final gold = tester.widget<Material>(
      find.descendant(
        of: find.byType(CommitButton),
        matching: find.byType(Material),
      ),
    );
    expect(gold.color, OColors.commit);

    await tester.pump();
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const Key('purpose-stage-capture')),
    );
    final image = await tester.runAsync(
      () => boundary.toImage(pixelRatio: 1.5),
    );
    final bytes = await tester.runAsync(
      () => image!.toByteData(format: ui.ImageByteFormat.png),
    );
    File('${out.path}/expanded_purpose_commit_gold.png').writeAsBytesSync(
      bytes!.buffer.asUint8List(),
    );
  }, skip: !capture);
}
