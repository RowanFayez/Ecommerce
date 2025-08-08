import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';
import '../utils/responsive_utils.dart';

/// A reusable spacing widget that provides consistent spacing throughout the app
class AppSpacing extends StatelessWidget {
  final double spacing;
  final bool isHorizontal;
  final bool isResponsive;

  const AppSpacing({
    super.key,
    this.spacing = AppDimensions.spacing16,
    this.isHorizontal = false,
    this.isResponsive = true,
  });

  /// Predefined spacing values for common use cases
  const AppSpacing.small({super.key, this.isHorizontal = false, this.isResponsive = true})
      : spacing = AppDimensions.spacing8;

  const AppSpacing.medium({super.key, this.isHorizontal = false, this.isResponsive = true})
      : spacing = AppDimensions.spacing16;

  const AppSpacing.large({super.key, this.isHorizontal = false, this.isResponsive = true})
      : spacing = AppDimensions.spacing24;

  const AppSpacing.xlarge({super.key, this.isHorizontal = false, this.isResponsive = true})
      : spacing = AppDimensions.spacing32;

  @override
  Widget build(BuildContext context) {
    final finalSpacing = isResponsive
        ? ResponsiveUtils.getResponsiveSpacing(context, spacing)
        : spacing;

    return isHorizontal
        ? SizedBox(width: finalSpacing)
        : SizedBox(height: finalSpacing);
  }
}

/// A reusable padding widget that provides consistent padding throughout the app
class AppPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool isResponsive;
  final double? all;
  final double? horizontal;
  final double? vertical;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const AppPadding({
    super.key,
    required this.child,
    this.padding,
    this.isResponsive = true,
    this.all,
    this.horizontal,
    this.vertical,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  /// Predefined padding values for common use cases
  const AppPadding.small({
    super.key,
    required this.child,
    this.isResponsive = true,
  })  : padding = null,
        all = AppDimensions.spacing8,
        horizontal = null,
        vertical = null,
        top = null,
        bottom = null,
        left = null,
        right = null;

  const AppPadding.medium({
    super.key,
    required this.child,
    this.isResponsive = true,
  })  : padding = null,
        all = AppDimensions.spacing16,
        horizontal = null,
        vertical = null,
        top = null,
        bottom = null,
        left = null,
        right = null;

  const AppPadding.large({
    super.key,
    required this.child,
    this.isResponsive = true,
  })  : padding = null,
        all = AppDimensions.spacing24,
        horizontal = null,
        vertical = null,
        top = null,
        bottom = null,
        left = null,
        right = null;

  const AppPadding.horizontal({
    super.key,
    required this.child,
    this.horizontal = AppDimensions.spacing16,
    this.isResponsive = true,
  })  : padding = null,
        all = null,
        vertical = null,
        top = null,
        bottom = null,
        left = null,
        right = null;

  const AppPadding.vertical({
    super.key,
    required this.child,
    this.vertical = AppDimensions.spacing16,
    this.isResponsive = true,
  })  : padding = null,
        all = null,
        horizontal = null,
        top = null,
        bottom = null,
        left = null,
        right = null;

  @override
  Widget build(BuildContext context) {
    EdgeInsets finalPadding;

    if (padding != null) {
      finalPadding = padding!;
    } else {
      double topValue = top ?? 0;
      double bottomValue = bottom ?? 0;
      double leftValue = left ?? 0;
      double rightValue = right ?? 0;

      if (all != null) {
        topValue = bottomValue = leftValue = rightValue = all!;
      }
      if (horizontal != null) {
        leftValue = rightValue = horizontal!;
      }
      if (vertical != null) {
        topValue = bottomValue = vertical!;
      }

      finalPadding = EdgeInsets.only(
        top: topValue,
        bottom: bottomValue,
        left: leftValue,
        right: rightValue,
      );
    }

    if (isResponsive) {
      finalPadding = EdgeInsets.only(
        top: ResponsiveUtils.getResponsiveSpacing(context, finalPadding.top),
        bottom: ResponsiveUtils.getResponsiveSpacing(context, finalPadding.bottom),
        left: ResponsiveUtils.getResponsiveSpacing(context, finalPadding.left),
        right: ResponsiveUtils.getResponsiveSpacing(context, finalPadding.right),
      );
    }

    return Padding(padding: finalPadding, child: child);
  }
} 