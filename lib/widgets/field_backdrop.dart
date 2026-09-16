import 'package:flutter/material.dart';

import '../theme/o_theme.dart';

/// Living wash — jade `#2f6f5e` → baby blue `#A8D4E8` → air `#F7FBFD`.
///
/// Inspired field, not an obsidian vault and not grey dark-mode chrome.
/// When [deepened], the wash leans further into jade for an expanded Purpose.
class FieldBackdrop extends StatelessWidget {
  const FieldBackdrop({
    super.key,
    required this.child,
    this.deepened = false,
  });

  final Widget child;
  final bool deepened;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: const [
            OColors.fieldJade,
            OColors.fieldBlue,
            OColors.fieldAir,
          ],
          stops: deepened ? const [0.0, 0.55, 1.0] : const [0.0, 0.42, 1.0],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: IgnorePointer(child: _AirWash())),
          if (deepened)
            const Positioned.fill(child: IgnorePointer(child: _DeepJade())),
          const Positioned(
            right: 22,
            top: 64,
            child: IgnorePointer(child: _AmbientOWisp()),
          ),
          child,
        ],
      ),
    );
  }
}

/// Extra jade when a Purpose holds the stage.
class _DeepJade extends StatelessWidget {
  const _DeepJade();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            OColors.fieldJade.withValues(alpha: 0.32),
            OColors.fieldBlue.withValues(alpha: 0.10),
            const Color(0x00F7FBFD),
          ],
        ),
      ),
    );
  }
}

/// Soft gold wisp on the field — ō is present, not a destination.
class _AmbientOWisp extends StatelessWidget {
  const _AmbientOWisp();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              OColors.commitSoft.withValues(alpha: 0.55),
              OColors.commit.withValues(alpha: 0.18),
              const Color(0x00F7FBFD),
            ],
            stops: const [0.0, 0.42, 1.0],
          ),
        ),
      ),
    );
  }
}

class _AirWash extends StatelessWidget {
  const _AirWash();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _AirWashPainter());
  }
}

class _AirWashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final air = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.15, -0.55),
        radius: 1.05,
        colors: [
          OColors.fieldAir.withValues(alpha: 0.85),
          OColors.fieldBlue.withValues(alpha: 0.18),
          const Color(0x00F7FBFD),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, air);

    final bloom = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.7, 0.85),
        radius: 0.85,
        colors: [
          OColors.fieldJade.withValues(alpha: 0.35),
          OColors.fieldBlue.withValues(alpha: 0.08),
          const Color(0x00A8D4E8),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bloom);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
