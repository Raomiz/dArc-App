import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'data/o_app_state.dart';
import 'data/o_companion.dart';
import 'data/o_store.dart';
import 'theme/o_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: OColors.fieldAir,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final state = OAppState(
    store: PrefsOStore(),
    companion: const StubOCompanion(),
  );
  await state.hydrate();
  runApp(OApp(state: state));
}
