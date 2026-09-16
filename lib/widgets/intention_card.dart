import 'package:flutter/material.dart';

import '../models/intention.dart';
import '../theme/o_theme.dart';
import 'commit_button.dart';

/// Intention on the Purpose stage — frost, not a demo card.
///
/// One status line. Gold lives only on the active verb.
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

  bool get _canCommit =>
      intention.status == IntentionStatus.brewing && onCommit != null;

  String get _statusLine {
    final bits = <String>[
      intention.status.label,
      if (intention.whenLabel != null && intention.whenLabel!.trim().isNotEmpty)
        intention.whenLabel!.trim(),
      if (intention.people.isEmpty)
        'Nobody else is here yet'
      else
        intention.people.join(' · '),
    ];
    return bits.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OColors.fieldAir.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(intention.title, style: OType.intentionTitle),
            const SizedBox(height: 6),
            Text(
              intention.statement,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: OType.bodyMist,
            ),
            const SizedBox(height: 8),
            Text(
              _statusLine,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: OType.bodyMist.copyWith(fontSize: 13),
            ),
            if (_canCommit) ...[
              const SizedBox(height: 14),
              _ActiveVerb(
                child: CommitButton(
                  label: 'Commit this intention',
                  onPressed: onCommit,
                ),
              ),
            ],
            if (onCoordinate != null) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: _ActiveVerb(
                  active: !_canCommit,
                  child: TextButton(
                    onPressed: onCoordinate,
                    style: TextButton.styleFrom(
                      foregroundColor: _canCommit
                          ? OColors.muted
                          : OColors.purposeDeep,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 6,
                      ),
                    ),
                    child: const Text(
                      'Coordinate with ō',
                      style: TextStyle(
                        fontFamily: OType.uiSans,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            if (onMore != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onMore,
                  style: TextButton.styleFrom(
                    foregroundColor: OColors.muted,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  child: const Text(
                    'More',
                    style: TextStyle(fontFamily: OType.uiSans),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Gold pulse on the verb that is live. Static halo so tests can settle.
class _ActiveVerb extends StatelessWidget {
  const _ActiveVerb({required this.child, this.active = true});

  final Widget child;
  final bool active;

  @override
  Widget build(BuildContext context) {
    if (!active) return child;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: OColors.commitSoft.withValues(alpha: 0.38),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
