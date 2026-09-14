import 'package:flutter/material.dart';

import '../theme/o_theme.dart';

/// Distant dusk field — aerial, not a desk.
class FieldBackdrop extends StatelessWidget {
  const FieldBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A1430),
            OColors.night,
            Color(0xFF07060A),
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: IgnorePointer(child: _Horizon())),
          child,
        ],
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
        colors: [Color(0x337A3BA8), Color(0x000C0A12)],
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
    canvas.drawPath(ridge, Paint()..color = const Color(0x22161A12));

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
