import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../theme/o_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/intention_card.dart';
import '../widgets/night_backdrop.dart';
import '../widgets/sam_navigator.dart';
import 'compose_intention_screen.dart';
import 'intention_detail_screen.dart';

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
        return NightBackdrop(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Purpose'),
              actions: const [SamNavigatorButton()],
            ),
            floatingActionButton: purpose == null
                ? null
                : FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ComposeIntentionScreen(
                            state: state,
                            purposeId: purposeId,
                          ),
                        ),
                      );
                    },
                    backgroundColor: OColors.intention,
                    foregroundColor: OColors.ground,
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
                        '${purpose.why}\n\nNo intention yet. Commit one — a named move with people.',
                    accent: OColors.intention,
                    primaryLabel: 'Commit an intention',
                    onPrimary: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ComposeIntentionScreen(
                            state: state,
                            purposeId: purposeId,
                          ),
                        ),
                      );
                    },
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
                        style: OType.whisper.copyWith(color: OColors.intentionLit),
                      ),
                      const SizedBox(height: 12),
                      for (final intention in items) ...[
                        IntentionCard(
                          intention: intention,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => IntentionDetailScreen(
                                  state: state,
                                  intentionId: intention.id,
                                ),
                              ),
                            );
                          },
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
