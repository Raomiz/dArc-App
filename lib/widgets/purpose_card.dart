import 'package:flutter/material.dart';

import '../models/purpose.dart';
import '../theme/o_theme.dart';

class PurposeCard extends StatelessWidget {
  const PurposeCard({
    super.key,
    required this.purpose,
    required this.intentionCount,
    required this.onTap,
  });

  final Purpose purpose;
  final int intentionCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final countLabel = intentionCount == 1
        ? '1 intention'
        : '$intentionCount intentions';

    return Material(
      color: OColors.surface.withValues(alpha: 0.88),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: OColors.purpose.withValues(alpha: 0.28)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PURPOSE',
                  style: OType.whisper.copyWith(color: OColors.purpose),
                ),
                const SizedBox(height: 10),
                Text(
                  purpose.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    fontFamily: OType.uiSans,
                    color: OColors.purposeDeep,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  purpose.why,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: OColors.muted,
                    height: 1.4,
                    fontFamily: OType.uiSans,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  countLabel,
                  style: const TextStyle(
                    color: OColors.intention,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: OType.uiSans,
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
