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
      color: OColors.field,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: OColors.byzantineDeep),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PURPOSE',
                  style: TextStyle(
                    color: OColors.byzantine,
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  purpose.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
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
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  countLabel,
                  style: const TextStyle(
                    color: OColors.jadeSoft,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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
