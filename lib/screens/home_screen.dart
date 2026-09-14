import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../theme/o_theme.dart';
import '../widgets/action_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/field_backdrop.dart';
import 'action_detail_screen.dart';
import 'compose_action_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.state});

  final OAppState state;

  @override
  Widget build(BuildContext context) {
    final name = state.session?.displayName ?? 'You';
    return FieldBackdrop(
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
                builder: (_) => ComposeActionScreen(state: state),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Start an action'),
        ),
        body: ListenableBuilder(
          listenable: state,
          builder: (context, _) {
            if (state.actions.isEmpty) {
              return EmptyState(
                title: 'Nothing in motion yet',
                body:
                    'Start an action — a walk, a meal, a thing that needs other people. '
                    'ō will help you coordinate. This is not a feed.',
                primaryLabel: 'Start an action',
                onPrimary: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ComposeActionScreen(state: state),
                    ),
                  );
                },
                secondaryLabel: 'Load sample actions',
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
                  'What are we doing?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Actions and intents — not posts. Open one and ask ō to help you move.',
                  style: TextStyle(color: OColors.muted, height: 1.4),
                ),
                const SizedBox(height: 20),
                for (final action in state.actions) ...[
                  ActionCard(
                    action: action,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ActionDetailScreen(
                            state: state,
                            actionId: action.id,
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
