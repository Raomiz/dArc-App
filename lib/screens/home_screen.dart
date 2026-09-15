import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../theme/o_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/field_backdrop.dart';
import '../widgets/intention_card.dart';
import '../widgets/sam_navigator.dart';
import 'compose_intention_screen.dart';
import 'compose_purpose_screen.dart';
import 'intention_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.state});

  final OAppState state;

  @override
  Widget build(BuildContext context) {
    final name = state.sessionName ?? 'You';
    return FieldBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'ō',
            style: TextStyle(
              color: OColors.commit,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            const SamNavigatorButton(),
            TextButton(
              onPressed: () => state.leave(),
              child: const Text(
                'Leave',
                style: TextStyle(color: OColors.muted),
              ),
            ),
          ],
        ),
        floatingActionButton: ListenableBuilder(
          listenable: state,
          builder: (context, _) {
            final purpose = state.focusedPurpose;
            if (purpose == null) {
              return FloatingActionButton.extended(
                onPressed: () => _openPurpose(context),
                backgroundColor: OColors.purpose,
                foregroundColor: OColors.paper,
                icon: const Icon(Icons.add),
                label: const Text('Name a purpose'),
              );
            }
            return FloatingActionButton.extended(
              onPressed: () => _openIntention(context, purpose.id),
              backgroundColor: OColors.intention,
              foregroundColor: OColors.paper,
              icon: const Icon(Icons.how_to_reg_outlined),
              label: const Text('Commit an intention'),
            );
          },
        ),
        body: ListenableBuilder(
          listenable: state,
          builder: (context, _) {
            final purpose = state.focusedPurpose;
            if (purpose == null) {
              return EmptyState(
                title: 'The field is open',
                body:
                    'Hello, $name. Name a purpose — a quiet north star. '
                    'Then commit an intention and move. Nobody else is here yet.',
                accent: OColors.purpose,
                primaryLabel: 'Name a purpose',
                onPrimary: () => _openPurpose(context),
              );
            }

            final items = state.intentionsFor(purpose.id);
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
              children: [
                Text(
                  'Hello, $name',
                  style: const TextStyle(color: OColors.muted, fontSize: 14),
                ),
                const SizedBox(height: 18),
                Text(
                  'PURPOSE',
                  style: OType.whisper.copyWith(color: OColors.purpose),
                ),
                const SizedBox(height: 8),
                Text(
                  purpose.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.6,
                    color: OColors.purposeDeep,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  purpose.why,
                  style: const TextStyle(
                    color: OColors.muted,
                    height: 1.4,
                    fontSize: 15,
                  ),
                ),
                if (state.purposes.length > 1) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final item in state.purposes)
                        ChoiceChip(
                          label: Text(item.title),
                          selected: item.id == purpose.id,
                          onSelected: (_) => state.focusPurpose(item.id),
                          selectedColor: OColors.fieldBlue,
                          backgroundColor: OColors.surface.withValues(
                            alpha: 0.7,
                          ),
                          labelStyle: TextStyle(
                            color: OColors.purposeDeep,
                            fontWeight: item.id == purpose.id
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontFamily: OType.uiSans,
                          ),
                          side: BorderSide.none,
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => _openPurpose(context),
                    child: const Text(
                      'Name another purpose',
                      style: TextStyle(color: OColors.purpose),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'INTENTIONS',
                  style: OType.whisper.copyWith(color: OColors.intention),
                ),
                const SizedBox(height: 8),
                Text(
                  'What you commit to do.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.35,
                  ),
                ),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  EmptyState(
                    title: 'The stage is yours',
                    body:
                        'Commit an intention that achieves this purpose. '
                        'ō coordinates when you ask. Nobody else is here yet.',
                    accent: OColors.intention,
                    primaryLabel: 'Commit an intention',
                    onPrimary: () => _openIntention(context, purpose.id),
                  )
                else
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
            );
          },
        ),
      ),
    );
  }

  void _openPurpose(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ComposePurposeScreen(state: state),
      ),
    );
  }

  void _openIntention(BuildContext context, String purposeId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ComposeIntentionScreen(
          state: state,
          purposeId: purposeId,
        ),
      ),
    );
  }
}
