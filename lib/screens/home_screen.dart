import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../nav/o_paces.dart';
import '../theme/o_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/field_backdrop.dart';
import '../widgets/intention_card.dart';
import '../widgets/o_navigator.dart';
import 'compose_intention_screen.dart';
import 'compose_purpose_screen.dart';
import 'intention_detail_screen.dart';

/// Home lands on **New Purpose**. Intention follows from that north star.
///
/// Dennis lock: Purpose, Commit, ō, and feed evidence are here or
/// one sheet out — never a fourth pace.
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
            const ONavigatorButton(),
            TextButton(
              onPressed: () => state.leave(),
              child: const Text(
                'Leave',
                style: TextStyle(color: OColors.muted),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => openComposePurposeSheet(
            context: context,
            state: state,
          ),
          backgroundColor: OColors.purpose,
          foregroundColor: OColors.paper,
          icon: const Icon(Icons.add),
          label: const Text('New Purpose'),
        ),
        body: ListenableBuilder(
          listenable: state,
          builder: (context, _) {
            final purpose = state.focusedPurpose;
            if (purpose == null) {
              return EmptyState(
                title: 'New Purpose',
                body:
                    'Hello, $name. This is the land — name a purpose. '
                    'Intentions follow from that north star. Nobody else is here yet.',
                accent: OColors.purpose,
                primaryLabel: 'New Purpose',
                onPrimary: () => openComposePurposeSheet(
                  context: context,
                  state: state,
                ),
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
                    onPressed: () => openComposePurposeSheet(
                      context: context,
                      state: state,
                    ),
                    child: const Text(
                      'New Purpose',
                      style: TextStyle(color: OColors.purpose),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'INTENTIONS',
                  style: OType.whisper.copyWith(color: OColors.intention),
                ),
                const SizedBox(height: 6),
                const Text(
                  'What follows this purpose.',
                  style: TextStyle(color: OColors.muted, fontSize: 15),
                ),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  EmptyState(
                    title: 'Intention follows',
                    body:
                        'Commit an intention that achieves this purpose. '
                        'ō coordinates when you ask. Nobody else is here yet.',
                    accent: OColors.intention,
                    primaryLabel: 'Commit an intention',
                    onPrimary: () => openComposeIntentionSheet(
                      context: context,
                      state: state,
                      purposeId: purpose.id,
                    ),
                  )
                else
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
            );
          },
        ),
      ),
    );
  }
}
