import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Load Inter so cinematic proofs render real strings, not Ahem blocks.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final loader = FontLoader('Inter')
    ..addFont(rootBundle.load('fonts/Inter-Regular.ttf'))
    ..addFont(rootBundle.load('fonts/Inter-Medium.ttf'))
    ..addFont(rootBundle.load('fonts/Inter-SemiBold.ttf'))
    ..addFont(rootBundle.load('fonts/Inter-Bold.ttf'));
  await loader.load();
  await testMain();
}
