import 'package:flutter/material.dart';

// Custom Clipper for creating the notch at the bottom of the image
class NotchedBottomClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double notchWidth;

  NotchedBottomClipper({
    required this.notchRadius,
    required this.notchWidth,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width - (notchWidth / 2) - 20; // Position from right
    final notchCenterY = size.height;

    // Start from top left
    path.moveTo(0, 0);

    // Top edge
    path.lineTo(size.width, 0);

    // Right edge down to notch start
    path.lineTo(size.width, notchCenterY);

    // Bottom edge to notch start
    path.lineTo(centerX + (notchWidth / 2), notchCenterY);

    // Create smooth notch curve
    path.quadraticBezierTo(
      centerX,
      notchCenterY - notchRadius,
      centerX - (notchWidth / 2),
      notchCenterY,
    );

    // Continue bottom edge
    path.lineTo(0, notchCenterY);

    // Left edge up
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

