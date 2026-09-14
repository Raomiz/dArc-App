import 'package:flutter/material.dart';

import '../data/o_app_state.dart';
import '../models/action_intent.dart';
import '../theme/o_theme.dart';
import '../widgets/companion_sheet.dart';
import '../widgets/field_backdrop.dart';

class ActionDetailScreen extends StatelessWidget {
  const ActionDetailScreen({
    super.key,
    required this.state,
    required this.actionId,
  });

  final OAppState state;
  final String actionId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final action = state.byId(actionId);
        return FieldBackdrop(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Action'),
            ),
            body: action == null
                ? const Center(
                    child: Text(
                      'This action is gone.',
                      style: TextStyle(color: OColors.muted),
                    ),
                  )
                : _Body(state: state, action: action),
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.action});

  final OAppState state;
  final ActionIntent action;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (action.status) {
      ActionStatus.brewing => OColors.gold,
      ActionStatus.inMotion => OColors.jadeSoft,
      ActionStatus.done => OColors.muted,
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Text(
          action.status.label.toUpperCase(),
          style: TextStyle(
            color: statusColor,
            letterSpacing: 1.3,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          action.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
          ),
        ),
        if (action.whenLabel != null) ...[
          const SizedBox(height: 8),
          Text(
            action.whenLabel!,
            style: const TextStyle(color: OColors.goldSoft, fontSize: 15),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          action.intent,
          style: const TextStyle(height: 1.5, fontSize: 16, color: OColors.paper),
        ),
        const SizedBox(height: 20),
        const Text(
          'People',
          style: TextStyle(color: OColors.muted, fontSize: 13, letterSpacing: 0.6),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final person in action.people)
              Chip(
                label: Text(person),
                backgroundColor: OColors.ridge,
                side: BorderSide.none,
                labelStyle: const TextStyle(color: OColors.paper),
              ),
          ],
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: () => openCompanionSheet(
            context: context,
            state: state,
            action: action,
          ),
          style: FilledButton.styleFrom(
            backgroundColor: OColors.gold,
            foregroundColor: OColors.night,
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
          'ō drafts next moves. The stub does not message anyone or call a model.',
          style: TextStyle(color: OColors.muted, fontSize: 13, height: 1.35),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => state.cycleStatus(action.id),
          style: OutlinedButton.styleFrom(
            foregroundColor: OColors.paper,
            minimumSize: const Size.fromHeight(50),
            side: const BorderSide(color: Color(0xFF3D3450)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text('Mark as ${action.status.next.label.toLowerCase()}'),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () async {
            await state.removeAction(action.id);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text(
            'Remove this action',
            style: TextStyle(color: Color(0xFFCF6679)),
          ),
        ),
      ],
    );
  }
}
