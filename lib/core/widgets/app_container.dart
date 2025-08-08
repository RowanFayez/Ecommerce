import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/responsive_utils.dart';

/// A reusable container widget that provides consistent styling throughout the app
class AppContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxShape? shape;
  final AlignmentGeometry? alignment;
  final Clip? clipBehavior;
  final Decoration? decoration;
  final bool isResponsive;

  const AppContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.boxShadow,
    this.shape,
    this.alignment,
    this.clipBehavior,
    this.decoration,
    this.isResponsive = true,
  });

  /// Predefined container styles for common use cases
  const AppContainer.card({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.alignment,
    this.clipBehavior,
    this.isResponsive = true,
  })  : borderColor = null,
        borderWidth = null,
        shape = null,
        decoration = null;

  const AppContainer.elevated({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.alignment,
    this.clipBehavior,
    this.isResponsive = true,
  })  : borderColor = null,
        borderWidth = null,
        shape = null,
        boxShadow = null,
        decoration = null;

  const AppContainer.outlined({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.alignment,
    this.clipBehavior,
    this.isResponsive = true,
  })  : boxShadow = null,
        shape = null,
        decoration = null;

  const AppContainer.rounded({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.alignment,
    this.clipBehavior,
    this.isResponsive = true,
  })  : borderRadius = AppDimensions.radiusLarge,
        shape = null,
        decoration = null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Apply responsive spacing if enabled
    EdgeInsetsGeometry? finalPadding = padding;
    EdgeInsetsGeometry? finalMargin = margin;
    double? finalBorderRadius = borderRadius;
    double? finalBorderWidth = borderWidth;

    if (isResponsive) {
      if (finalPadding != null) {
        finalPadding = EdgeInsets.only(
          top: ResponsiveUtils.getResponsiveSpacing(
              context, finalPadding.resolve(TextDirection.ltr).top),
          bottom: ResponsiveUtils.getResponsiveSpacing(
              context, finalPadding.resolve(TextDirection.ltr).bottom),
          left: ResponsiveUtils.getResponsiveSpacing(
              context, finalPadding.resolve(TextDirection.ltr).left),
          right: ResponsiveUtils.getResponsiveSpacing(
              context, finalPadding.resolve(TextDirection.ltr).right),
        );
      }
      if (finalMargin != null) {
        finalMargin = EdgeInsets.only(
          top: ResponsiveUtils.getResponsiveSpacing(
              context, finalMargin.resolve(TextDirection.ltr).top),
          bottom: ResponsiveUtils.getResponsiveSpacing(
              context, finalMargin.resolve(TextDirection.ltr).bottom),
          left: ResponsiveUtils.getResponsiveSpacing(
              context, finalMargin.resolve(TextDirection.ltr).left),
          right: ResponsiveUtils.getResponsiveSpacing(
              context, finalMargin.resolve(TextDirection.ltr).right),
        );
      }
      if (finalBorderRadius != null) {
        finalBorderRadius =
            ResponsiveUtils.getResponsiveSpacing(context, finalBorderRadius);
      }
      if (finalBorderWidth != null) {
        finalBorderWidth =
            ResponsiveUtils.getResponsiveSpacing(context, finalBorderWidth);
      }
    }

    // Build decoration
    Decoration? finalDecoration = decoration;
    if (finalDecoration == null) {
      finalDecoration = BoxDecoration(
        color:
            color ?? (isDark ? AppColors.darkCard : AppColors.cardBackground),
        borderRadius: finalBorderRadius != null
            ? BorderRadius.circular(finalBorderRadius)
            : null,
        border: borderColor != null || finalBorderWidth != null
            ? Border.all(
                color: borderColor ??
                    (isDark ? AppColors.darkBorder : AppColors.borderLight),
                width: finalBorderWidth ?? 1.0,
              )
            : null,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: AppDimensions.blurRadiusSmall,
                offset: const Offset(0, 2),
              ),
            ],
        shape: shape ?? BoxShape.rectangle,
      );
    }

    return Container(
      width: width,
      height: height,
      padding: finalPadding,
      margin: finalMargin,
      decoration: finalDecoration,
      alignment: alignment,
      clipBehavior: clipBehavior ?? Clip.none,
      child: child,
    );
  }
}

/// A reusable card container widget
class AppCard extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final AlignmentGeometry? alignment;
  final Clip? clipBehavior;
  final bool isResponsive;

  const AppCard({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.alignment,
    this.clipBehavior,
    this.isResponsive = true,
  });

  AppCard.small({
    super.key,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.alignment,
    this.clipBehavior,
    this.isResponsive = true,
  })  : padding = EdgeInsets.all(AppDimensions.spacing8),
        super();

  AppCard.medium({
    super.key,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.alignment,
    this.clipBehavior,
    this.isResponsive = true,
  })  : padding = EdgeInsets.all(AppDimensions.spacing16),
        super();

  AppCard.large({
    super.key,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.alignment,
    this.clipBehavior,
    this.isResponsive = true,
  })  : padding = EdgeInsets.all(AppDimensions.spacing24),
        super();

  @override
  Widget build(BuildContext context) {
    return AppContainer.card(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderRadius: borderRadius ?? AppDimensions.radiusLarge,
      boxShadow: boxShadow,
      alignment: alignment,
      clipBehavior: clipBehavior,
      isResponsive: isResponsive,
      child: child,
    );
  }
}
