import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../nav/o_paces.dart';
import '../theme/o_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/field_backdrop.dart';
import '../widgets/intention_card.dart';
import '../widgets/sam_navigator.dart';
import 'compose_intention_screen.dart';
import 'intention_detail_screen.dart';

/// Quiet purpose view. Not the main path — home is the Intention stage.
class PurposeDetailScreen extends StatelessWidget {
  const PurposeDetailScreen({
    super.key,
    required this.state,
    required this.purposeId,
  });

  final OAppState state;
  final String purposeId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final purpose = state.purposeById(purposeId);
        final items = state.intentionsFor(purposeId);
        return FieldBackdrop(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Purpose'),
              actions: const [SamNavigatorButton()],
            ),
            floatingActionButton: purpose == null
                ? null
                : FloatingActionButton.extended(
                    onPressed: () => openComposeIntentionSheet(
                      context: context,
                      state: state,
                      purposeId: purposeId,
                    ),
                    backgroundColor: OColors.intention,
                    foregroundColor: OColors.paper,
                    icon: const Icon(Icons.how_to_reg_outlined),
                    label: const Text('Commit an intention'),
                  ),
            body: purpose == null
                ? const Center(
                    child: Text(
                      'This purpose is gone.',
                      style: TextStyle(color: OColors.muted),
                    ),
                  )
                : items.isEmpty
                ? EmptyState(
                    title: purpose.title,
                    body:
                        '${purpose.why}\n\nNo intention yet. Commit one — the move that achieves this purpose.',
                    accent: OColors.intention,
                    primaryLabel: 'Commit an intention',
                    onPrimary: () => openComposeIntentionSheet(
                      context: context,
                      state: state,
                      purposeId: purposeId,
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                    children: [
                      Text(
                        'PURPOSE',
                        style: OType.whisper.copyWith(color: OColors.purpose),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        purpose.title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.6,
                              color: OColors.purposeDeep,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        purpose.why,
                        style: const TextStyle(
                          color: OColors.muted,
                          height: 1.45,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Intentions',
                        style: OType.whisper.copyWith(color: OColors.intention),
                      ),
                      const SizedBox(height: 12),
                      for (final intention in items) ...[
                        IntentionCard(
                          intention: intention,
                          onCommit: () => state.commitIntention(intention.id),
                          onCoordinate: () => openCompanionFromStage(
                            context: context,
                            state: state,
                            intention: intention,
                          ),
                          onMore: () => openIntentionMoreSheet(
                            context: context,
                            state: state,
                            intentionId: intention.id,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }
}
