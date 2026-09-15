import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../models/intention.dart';
import '../theme/o_theme.dart';
import '../widgets/companion_sheet.dart';

/// Dennis lock — **2–3 paces from main**.
///
/// Home lands on New Purpose. Intention follows from that north star.
/// Commit, ō, and feed evidence must be reachable in at most three taps.
/// Secondary lives one step out (a sheet). Rarely anything at three.
/// A fourth pace fails. No deeper stacks. No buried settings for
/// primary actions.
const int maxPacesFromStage = 3;

Future<void> showOSheet({
  required BuildContext context,
  required Widget child,
  double heightFactor = 0.88,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: OColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * heightFactor,
          child: child,
        ),
      );
    },
  );
}

Future<void> openCompanionFromStage({
  required BuildContext context,
  required OAppState state,
  required Intention intention,
}) {
  return openCompanionSheet(
    context: context,
    state: state,
    intention: intention,
    purpose: state.purposeById(intention.purposeId),
  );
}
