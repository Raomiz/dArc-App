import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../theme/o_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/night_backdrop.dart';
import '../widgets/purpose_card.dart';
import '../widgets/sam_navigator.dart';
import 'compose_purpose_screen.dart';
import 'purpose_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.state});

  final OAppState state;

  @override
  Widget build(BuildContext context) {
    final name = state.session?.displayName ?? 'You';
    return NightBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'ō',
            style: TextStyle(
              color: OColors.gold,
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ComposePurposeScreen(state: state),
              ),
            );
          },
          backgroundColor: OColors.byzantine,
          foregroundColor: OColors.paper,
          icon: const Icon(Icons.add),
          label: const Text('Name a purpose'),
        ),
        body: ListenableBuilder(
          listenable: state,
          builder: (context, _) {
            if (state.purposes.isEmpty) {
              return EmptyState(
                title: 'No purpose yet',
                body:
                    'Name a purpose — why you want to act with other people. '
                    'Then commit an intention. ō coordinates. This is not a feed.',
                primaryLabel: 'Name a purpose',
                onPrimary: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ComposePurposeScreen(state: state),
                    ),
                  );
                },
                secondaryLabel: 'Load sample purposes',
                onSecondary: () => state.loadSamples(),
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
              children: [
                Text(
                  'Hello, $name',
                  style: const TextStyle(color: OColors.muted, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'What is the purpose?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Purpose is why. Intention is what you commit. Open one and move.',
                  style: TextStyle(color: OColors.muted, height: 1.4),
                ),
                const SizedBox(height: 20),
                for (final purpose in state.purposes) ...[
                  PurposeCard(
                    purpose: purpose,
                    intentionCount: state.intentionsFor(purpose.id).length,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => PurposeDetailScreen(
                            state: state,
                            purposeId: purpose.id,
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
}
