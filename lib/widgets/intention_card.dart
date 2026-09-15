import 'package:flutter/material.dart';

import '../models/intention.dart';
import '../theme/o_theme.dart';
import 'commit_button.dart';

/// Intention on the main stage — evidence + Commit + ō in one place.
///
/// Primary actions stay on the card so they are one pace from the stage.
class IntentionCard extends StatelessWidget {
  const IntentionCard({
    super.key,
    required this.intention,
    this.onCommit,
    this.onCoordinate,
    this.onMore,
  });

  final Intention intention;
  final VoidCallback? onCommit;
  final VoidCallback? onCoordinate;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (intention.status) {
      IntentionStatus.brewing => OColors.commit,
      IntentionStatus.committed => OColors.intention,
      IntentionStatus.done => OColors.muted,
    };

    return Material(
      color: OColors.surface.withValues(alpha: 0.88),
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: OColors.intention.withValues(alpha: 0.28)),
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
                    style: OType.whisper.copyWith(color: statusColor),
                  ),
                  const Spacer(),
                  if (intention.whenLabel != null)
                    Text(
                      intention.whenLabel!,
                      style: const TextStyle(
                        color: OColors.muted,
                        fontSize: 12,
                        fontFamily: OType.uiSans,
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
                  fontFamily: OType.uiSans,
                  color: OColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                intention.statement,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: OColors.muted,
                  height: 1.4,
                  fontFamily: OType.uiSans,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                intention.people.isEmpty
                    ? 'Nobody else is here yet'
                    : intention.people.join(' · '),
                style: const TextStyle(
                  color: OColors.purposeDeep,
                  fontSize: 13,
                  fontFamily: OType.uiSans,
                ),
              ),
              if (intention.status == IntentionStatus.brewing &&
                  onCommit != null) ...[
                const SizedBox(height: 16),
                CommitButton(
                  label: 'Commit this intention',
                  onPressed: onCommit,
                ),
              ],
              if (onCoordinate != null) ...[
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: onCoordinate,
                  style: FilledButton.styleFrom(
                    backgroundColor: OColors.commit,
                    foregroundColor: OColors.ink,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('Coordinate with ō'),
                ),
              ],
              if (onMore != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: onMore,
                    child: const Text(
                      'More',
                      style: TextStyle(color: OColors.muted),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
