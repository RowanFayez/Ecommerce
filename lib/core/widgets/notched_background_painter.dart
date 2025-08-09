import 'package:flutter/material.dart';

class NotchedBackgroundPainter extends CustomPainter {
  final double notchRadius;
  final Color backgroundColor;

  NotchedBackgroundPainter({
    this.notchRadius = 28,
    this.backgroundColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;

    path.moveTo(0, 0);
    path.lineTo(centerX - notchRadius, 0);

    // Notch curve (smooth semi-circle going upward)
    path.arcToPoint(
      Offset(centerX + notchRadius, 0),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw shadow for 3D effect
    canvas.drawShadow(path, Colors.black.withOpacity(0.08), 4, false);

    // Draw background
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
