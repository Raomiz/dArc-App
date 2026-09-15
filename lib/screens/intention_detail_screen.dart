import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../models/intention.dart';
import '../nav/o_paces.dart';
import '../theme/o_theme.dart';

/// Secondary more-sheet — cycle / remove. Not required for Commit or ō.
Future<void> openIntentionMoreSheet({
  required BuildContext context,
  required OAppState state,
  required String intentionId,
}) {
  return showOSheet(
    context: context,
    heightFactor: 0.52,
    child: IntentionMorePanel(state: state, intentionId: intentionId),
  );
}

class IntentionMorePanel extends StatelessWidget {
  const IntentionMorePanel({
    super.key,
    required this.state,
    required this.intentionId,
  });

  final OAppState state;
  final String intentionId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final intention = state.intentionById(intentionId);
        if (intention == null) {
          return const Center(
            child: Text(
              'This intention is gone.',
              style: TextStyle(color: OColors.muted),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: OColors.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              intention.status.label.toUpperCase(),
              style: OType.whisper.copyWith(color: OColors.intention),
            ),
            const SizedBox(height: 8),
            Text(
              intention.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: OColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              intention.statement,
              style: const TextStyle(height: 1.45, color: OColors.ink),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => state.cycleStatus(intention.id),
              style: OutlinedButton.styleFrom(
                foregroundColor: OColors.ink,
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: OColors.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Mark as ${intention.status.next.label.toLowerCase()}',
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                await state.removeIntention(intention.id);
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text(
                'Remove this intention',
                style: TextStyle(color: Color(0xFFCF6679)),
              ),
            ),
          ],
        );
      },
    );
  }
}
