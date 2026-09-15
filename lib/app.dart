import 'package:flutter/material.dart';

import 'data/o_app_state.dart';
import 'screens/gate_screen.dart';
import 'screens/home_screen.dart';
import 'theme/o_theme.dart';
import 'widgets/field_backdrop.dart';
import 'widgets/o_mark.dart';

class OApp extends StatelessWidget {
  const OApp({super.key, required this.state});

  final OAppState state;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ō',
      debugShowCheckedModeBanner: false,
      theme: buildOTheme(),
      home: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          if (!state.ready) {
            return const FieldBackdrop(
              child: Center(child: OMark(size: 88)),
            );
          }
          if (state.session == null) {
            return GateScreen(state: state);
          }
          return HomeScreen(state: state);
        },
      ),
    );
  }
}
