import 'package:flutter/material.dart';

import '../theme/o_theme.dart';

/// Obsidian vault ground — `#0c0712`, not flat grey and not `#050505`.
class NightBackdrop extends StatelessWidget {
  const NightBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            OColors.purposeDeep,
            OColors.ground,
            OColors.ground,
          ],
          stops: [0.0, 0.42, 1.0],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: IgnorePointer(child: _Horizon())),
          const Positioned(
            right: 28,
            top: 72,
            child: IgnorePointer(child: _AmbientSamWisp()),
          ),
          child,
        ],
      ),
    );
  }
}

/// Soft gold wisp in the vault — Sam is present, not a destination.
class _AmbientSamWisp extends StatelessWidget {
  const _AmbientSamWisp();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              OColors.commitSoft.withValues(alpha: 0.22),
              OColors.commit.withValues(alpha: 0.06),
              const Color(0x000C0712),
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
      ),
    );
  }
}

class _Horizon extends StatelessWidget {
  const _Horizon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _HorizonPainter());
  }
}

class _HorizonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final haze = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x33702963), Color(0x000C0712)],
      ).createShader(Rect.fromLTWH(0, size.height * 0.28, size.width, size.height * 0.4));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.28, size.width, size.height * 0.4),
      haze,
    );

    final ridge = Path()
      ..moveTo(0, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.56,
        size.width * 0.7,
        size.height * 0.63,
      )
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height * 0.66,
        size.width,
        size.height * 0.61,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(ridge, Paint()..color = OColors.surface.withValues(alpha: 0.55));

    final star = Paint()..color = const Color(0x66F4EFE4);
    const marks = [
      Offset(0.18, 0.12),
      Offset(0.72, 0.08),
      Offset(0.86, 0.2),
      Offset(0.42, 0.16),
      Offset(0.09, 0.24),
    ];
    for (final m in marks) {
      canvas.drawCircle(
        Offset(size.width * m.dx, size.height * m.dy),
        1.3,
        star,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
