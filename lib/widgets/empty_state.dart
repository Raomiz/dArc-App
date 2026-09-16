import 'package:flutter/material.dart';

import '../theme/o_theme.dart';
import 'commit_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.body,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.accent,
  });

  final String title;
  final String body;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final accentColor = accent ?? OColors.purpose;
    final onAccent = accentColor == OColors.commit ? OColors.ink : OColors.paper;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 3,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(title, style: OType.purposeTitle.copyWith(fontSize: 22)),
          const SizedBox(height: 10),
          Text(body, style: OType.bodyMist),
          const SizedBox(height: 28),
          if (primaryLabel != null && onPrimary != null)
            accentColor == OColors.commit
                ? CommitButton(label: primaryLabel!, onPressed: onPrimary)
                : FilledButton(
                    onPressed: onPrimary,
                    style: FilledButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: onAccent,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: OType.uiSans,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(primaryLabel!),
                  ),
          if (secondaryLabel != null && onSecondary != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onSecondary,
              style: OutlinedButton.styleFrom(
                foregroundColor: OColors.ink,
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(color: OColors.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(secondaryLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
