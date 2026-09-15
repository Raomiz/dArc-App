import 'package:flutter/material.dart';

import '../theme/o_theme.dart';

/// Sam is an ambient gold-soft wisp — the in-app navigator.
///
/// Not a Raz creature. Not a person on an intention. Not a chat destination
/// (ō coordinates; live chat is Grok). Opens a brief map of ō, not a thread.
Future<void> openSamNavigator(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: OColors.surface,
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
    return Semantics(
      button: true,
      label: 'Sam',
      child: InkWell(
        onTap: () => openSamNavigator(context),
        borderRadius: BorderRadius.circular(24),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(8, 6, 12, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SamWisp(size: 22),
              SizedBox(width: 8),
              Text(
                'Sam',
                style: TextStyle(
                  color: OColors.commitSoft,
                  fontWeight: FontWeight.w600,
                  fontFamily: OType.uiSans,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ambient gold-soft wisp. Presence, not a chat orb.
class SamWisp extends StatelessWidget {
  const SamWisp({super.key, this.size = 22});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              OColors.commitSoft,
              OColors.commit.withValues(alpha: 0.85),
              OColors.commit.withValues(alpha: 0.15),
            ],
            stops: const [0.0, 0.42, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: OColors.commitSoft.withValues(alpha: 0.45),
              blurRadius: size * 0.7,
              spreadRadius: 1,
            ),
          ],
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
                  color: OColors.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                SamWisp(size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sam',
                    style: TextStyle(
                      color: OColors.commitSoft,
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      fontFamily: OType.uiSans,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'In-app navigator',
              style: OType.whisper.copyWith(color: OColors.commitSoft),
            ),
            const SizedBox(height: 16),
            const Text(
              'I am Sam. I help you find your way through ō. '
              'I am a wisp, not a chat. I am not a game creature, and I do not belong to Raz.',
              style: TextStyle(height: 1.45, fontSize: 16, fontFamily: OType.uiSans),
            ),
            const SizedBox(height: 20),
            const _MapRow(
              color: OColors.purpose,
              title: 'Purpose',
              body: 'Why you act with other people.',
            ),
            const SizedBox(height: 12),
            const _MapRow(
              color: OColors.intention,
              title: 'Intention',
              body: 'What you commit to do. A named move with people.',
            ),
            const SizedBox(height: 12),
            const _MapRow(
              color: OColors.commit,
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
                  fontFamily: OType.uiSans,
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
