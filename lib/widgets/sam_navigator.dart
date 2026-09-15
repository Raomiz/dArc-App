import 'package:flutter/material.dart';

import '../theme/o_theme.dart';

/// Sam is the in-app navigator for the user.
///
/// Not a Raz creature. Not a person on an intention. Opens a map of ō.
Future<void> openSamNavigator(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: OColors.field,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => const SamNavigatorSheet(),
  );
}

class SamNavigatorButton extends StatelessWidget {
  const SamNavigatorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => openSamNavigator(context),
      child: const Text(
        'Sam',
        style: TextStyle(
          color: OColors.goldSoft,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SamNavigatorSheet extends StatelessWidget {
  const SamNavigatorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF3D3450),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Sam',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: OColors.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'In-app navigator',
              style: TextStyle(color: OColors.muted, fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'I am Sam. I help you find your way through ō. '
              'I am not a game creature, and I do not belong to Raz.',
              style: TextStyle(height: 1.45, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const _MapRow(
              color: OColors.byzantine,
              title: 'Purpose',
              body: 'Why you act with other people.',
            ),
            const SizedBox(height: 12),
            const _MapRow(
              color: OColors.jade,
              title: 'Intention',
              body: 'What you commit to do. A named move with people.',
            ),
            const SizedBox(height: 12),
            const _MapRow(
              color: OColors.gold,
              title: 'ō',
              body:
                  'Coordinates. When live, in-app chat is Grok — not OpenAI. This build is a stub.',
            ),
            const SizedBox(height: 20),
            const Text(
              'd-arc.io is the atlas door. This app is ō.',
              style: TextStyle(color: OColors.muted, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapRow extends StatelessWidget {
  const _MapRow({
    required this.color,
    required this.title,
    required this.body,
  });

  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: const TextStyle(color: OColors.paper, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
