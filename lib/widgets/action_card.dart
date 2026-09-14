import 'package:flutter/material.dart';

import '../models/action_intent.dart';
import '../theme/o_theme.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({super.key, required this.action, required this.onTap});

  final ActionIntent action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (action.status) {
      ActionStatus.brewing => OColors.gold,
      ActionStatus.inMotion => OColors.jadeSoft,
      ActionStatus.done => OColors.muted,
    };

    return Material(
      color: OColors.field,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2A2438)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      action.status.label.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (action.whenLabel != null)
                      Text(
                        action.whenLabel!,
                        style: const TextStyle(
                          color: OColors.muted,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  action.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  action.intent,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: OColors.muted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  action.people.isEmpty
                      ? 'No one named yet'
                      : action.people.join(' · '),
                  style: const TextStyle(
                    color: OColors.goldSoft,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
