import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../models/intention.dart';
import '../theme/o_theme.dart';
import '../widgets/commit_button.dart';
import '../widgets/companion_sheet.dart';
import '../widgets/night_backdrop.dart';

class IntentionDetailScreen extends StatelessWidget {
  const IntentionDetailScreen({
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
        return NightBackdrop(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Intention'),
            ),
            body: intention == null
                ? const Center(
                    child: Text(
                      'This intention is gone.',
                      style: TextStyle(color: OColors.muted),
                    ),
                  )
                : _Body(state: state, intention: intention),
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.intention});

  final OAppState state;
  final Intention intention;

  @override
  Widget build(BuildContext context) {
    final purpose = state.purposeById(intention.purposeId);
    final statusColor = switch (intention.status) {
      IntentionStatus.brewing => OColors.commit,
      IntentionStatus.committed => OColors.intentionLit,
      IntentionStatus.done => OColors.muted,
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        if (purpose != null) ...[
          Text(
            purpose.title.toUpperCase(),
            style: OType.whisper.copyWith(color: OColors.purpose),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          intention.status.label.toUpperCase(),
          style: OType.whisper.copyWith(color: statusColor),
        ),
        const SizedBox(height: 8),
        Text(
          intention.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
          ),
        ),
        if (intention.whenLabel != null) ...[
          const SizedBox(height: 8),
          Text(
            intention.whenLabel!,
            style: const TextStyle(color: OColors.commitSoft, fontSize: 15),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          intention.statement,
          style: const TextStyle(height: 1.5, fontSize: 16, color: OColors.paper),
        ),
        const SizedBox(height: 20),
        Text(
          'People',
          style: OType.whisper.copyWith(color: OColors.muted),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final person in intention.people)
              Chip(
                label: Text(person),
                backgroundColor: OColors.ridge,
                side: BorderSide.none,
                labelStyle: const TextStyle(color: OColors.paper),
              ),
          ],
        ),
        const SizedBox(height: 28),
        if (intention.status == IntentionStatus.brewing) ...[
          CommitButton(
            label: 'Commit this intention',
            onPressed: () => state.commitIntention(intention.id),
          ),
          const SizedBox(height: 10),
        ],
        FilledButton.icon(
          onPressed: () => openCompanionSheet(
            context: context,
            state: state,
            intention: intention,
            purpose: purpose,
          ),
          style: FilledButton.styleFrom(
            backgroundColor: OColors.commit,
            foregroundColor: OColors.ground,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.auto_awesome),
          label: const Text('Coordinate with ō'),
        ),
        const SizedBox(height: 8),
        const Text(
          'ō drafts next moves. When live, chat is Grok. This stub does not message anyone.',
          style: TextStyle(color: OColors.muted, fontSize: 13, height: 1.35),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => state.cycleStatus(intention.id),
          style: OutlinedButton.styleFrom(
            foregroundColor: OColors.paper,
            minimumSize: const Size.fromHeight(50),
            side: const BorderSide(color: OColors.outline),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text('Mark as ${intention.status.next.label.toLowerCase()}'),
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
  }
}
