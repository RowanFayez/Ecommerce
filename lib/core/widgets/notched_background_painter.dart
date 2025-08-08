import 'package:flutter/material.dart';

class NotchedBackgroundPainter extends CustomPainter {
  final double notchRadius;

  NotchedBackgroundPainter({this.notchRadius = 28});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    final double centerX = size.width / 2;

    path.moveTo(0, 0);
    path.lineTo(centerX - notchRadius, 0);

    // notch arc
    path.arcToPoint(
      Offset(centerX + notchRadius, 0),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
