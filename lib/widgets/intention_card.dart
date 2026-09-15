import 'package:flutter/material.dart';

import '../models/intention.dart';
import '../theme/o_theme.dart';

class IntentionCard extends StatelessWidget {
  const IntentionCard({super.key, required this.intention, required this.onTap});

  final Intention intention;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (intention.status) {
      IntentionStatus.brewing => OColors.gold,
      IntentionStatus.committed => OColors.jadeSoft,
      IntentionStatus.done => OColors.muted,
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
                      intention.status.label.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (intention.whenLabel != null)
                      Text(
                        intention.whenLabel!,
                        style: const TextStyle(
                          color: OColors.muted,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  intention.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  intention.statement,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: OColors.muted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  intention.people.isEmpty
                      ? 'No one named yet'
                      : intention.people.join(' · '),
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
