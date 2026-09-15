import 'package:flutter/material.dart';

import '../theme/o_theme.dart';

class OMark extends StatelessWidget {
  const OMark({super.key, this.size = 72, this.gold = true});

  final double size;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final color = gold ? OColors.commit : OColors.paper;
    return Semantics(
      label: 'ō',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _OMarkPainter(color)),
      ),
    );
  }
}

class _OMarkPainter extends CustomPainter {
  _OMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final inset = size.width * 0.18;
    final oval = Rect.fromLTWH(
      inset,
      inset + size.height * 0.06,
      size.width - inset * 2,
      size.height - inset * 2 - size.height * 0.04,
    );
    canvas.drawOval(oval, stroke);

    final bar = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;
    final y = size.height * 0.16;
    canvas.drawLine(
      Offset(size.width * 0.22, y),
      Offset(size.width * 0.78, y),
      bar,
    );
  }

  @override
  bool shouldRepaint(covariant _OMarkPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
