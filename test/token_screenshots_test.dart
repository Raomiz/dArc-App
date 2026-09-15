import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:darc_o/app.dart';
import 'package:darc_o/data/o_app_state.dart';
import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/data/o_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Writes phone-frame PNGs so the PR can show Joshua the vault tokens.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture gate, home, purpose, commit screens', (tester) async {
    final out = Directory('test/goldens');
    out.createSync(recursive: true);

    final state = OAppState(
      store: MemoryOStore(),
      companion: const StubOCompanion(),
      random: Random(3),
    );
    await state.hydrate();

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      RepaintBoundary(
        child: OApp(state: state),
      ),
    );
    await tester.pumpAndSettle();
    await _write(tester, out, 'gate_vault.png');

    await tester.enterText(find.byType(TextField), 'Joshua');
    await tester.tap(find.text('Enter ō locally'));
    await tester.pumpAndSettle();
    await _write(tester, out, 'home_empty.png');

    await tester.tap(find.text('Load sample purposes'));
    await tester.pumpAndSettle();
    await _write(tester, out, 'home_purposes.png');

    await tester.tap(find.text('Get outside this week'));
    await tester.pumpAndSettle();
    await _write(tester, out, 'purpose_intentions.png');

    await tester.tap(find.text('Evening walk'));
    await tester.pumpAndSettle();
    await _write(tester, out, 'intention_commit.png');
  });
}

Future<void> _write(WidgetTester tester, Directory out, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byType(RepaintBoundary).first,
  );
  final image = await boundary.toImage(pixelRatio: 2);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  File('${out.path}/$name').writeAsBytesSync(bytes!.buffer.asUint8List());
}
