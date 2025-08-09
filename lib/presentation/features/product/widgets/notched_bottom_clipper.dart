import 'package:flutter/material.dart';

/// A clipper that creates a rounded-rectangle image with a circular
/// cut-out (notch) at the bottom-center.
///
/// The result matches a shape like the screenshot: rounded top corners and
/// a circular notch subtracted from the bottom edge so a badge can sit in it.
class NotchedBottomClipper extends CustomClipper<Path> {
  /// Radius of the rounded rectangle's corners.
  final double cornerRadius;

  /// Radius of the circular notch to subtract from the bottom-center.
  final double notchRadius;

  /// Optional vertical offset to make the notch slightly overflow below
  /// the image, creating a tighter fit around the badge. Positive values
  /// move the circle down.
  final double notchVerticalOverflow;

  /// Multiplier for horizontally stretching the notch's circle into an oval.
  /// Values > 1.0 will create a smooth rounded "hill" shape.
  final double horizontalRadiusFactor;

  const NotchedBottomClipper({
    required this.cornerRadius,
    required this.notchRadius,
    this.notchVerticalOverflow = 0,
    this.horizontalRadiusFactor = 1.6,
  });

  @override
  Path getClip(Size size) {
    // Base rounded-rectangle covering the whole image area
    final rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: Radius.circular(cornerRadius),
      topRight: Radius.circular(cornerRadius),
      bottomLeft: Radius.circular(cornerRadius),
      bottomRight: Radius.circular(cornerRadius),
    );
    final roundedRectPath = Path()..addRRect(rect);

    // Circle centered horizontally at bottom, shifted slightly down
    final circleCenter = Offset(
      size.width / 2,
      size.height + notchVerticalOverflow,
    );
    final circlePath = Path()
      ..addOval(Rect.fromCenter(
        center: circleCenter,
        width: notchRadius * 2 * horizontalRadiusFactor,
        height: notchRadius * 2,
      ));

    // Subtract the circle from the rounded rectangle to create the notch
    final clipped = Path.combine(
      PathOperation.difference,
      roundedRectPath,
      circlePath,
    );
    return clipped;
  }

  @override
  bool shouldReclip(covariant NotchedBottomClipper oldClipper) {
    return cornerRadius != oldClipper.cornerRadius ||
        notchRadius != oldClipper.notchRadius ||
        notchVerticalOverflow != oldClipper.notchVerticalOverflow ||
        horizontalRadiusFactor != oldClipper.horizontalRadiusFactor;
  }
}
