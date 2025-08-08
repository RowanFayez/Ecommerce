import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/responsive_utils.dart';

/// A reusable text widget that provides consistent typography throughout the app
class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final bool isResponsive;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.isResponsive = true,
  });

  /// Predefined text styles for common use cases
  const AppText.heading(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.isResponsive = true,
  }) : super();

  const AppText.title(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.isResponsive = true,
  }) : super();

  const AppText.body(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.isResponsive = true,
  }) : super();

  const AppText.caption(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.isResponsive = true,
  }) : super();

  const AppText.button(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.isResponsive = true,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    TextStyle? finalStyle = style;
    
    // Apply responsive font size if enabled
    if (isResponsive && finalStyle?.fontSize != null) {
      finalStyle = finalStyle!.copyWith(
        fontSize: ResponsiveUtils.getResponsiveFontSize(
          context,
          finalStyle.fontSize!,
        ),
      );
    }

    // Apply default colors if not specified
    if (finalStyle?.color == null) {
      finalStyle = finalStyle?.copyWith(
        color: isDark ? AppColors.darkText : AppColors.textPrimary,
      ) ?? TextStyle(
        color: isDark ? AppColors.darkText : AppColors.textPrimary,
      );
    }

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

/// A reusable heading text widget
class AppHeading extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const AppHeading(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  const AppHeading.h1(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  }) : super();

  const AppHeading.h2(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  }) : super();

  const AppHeading.h3(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppText(
      text,
      style: TextStyle(
        fontSize: isResponsive
            ? ResponsiveUtils.getResponsiveFontSize(
                context,
                AppDimensions.fontHeading,
              )
            : AppDimensions.fontHeading,
        fontWeight: FontWeight.bold,
        color: color ?? (isDark ? AppColors.darkText : AppColors.textPrimary),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      isResponsive: false, // Already handled above
    );
  }
}

/// A reusable body text widget
class AppBodyText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isResponsive;

  const AppBodyText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  });

  const AppBodyText.primary(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  }) : super();

  const AppBodyText.secondary(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isResponsive = true,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppText(
      text,
      style: TextStyle(
        fontSize: isResponsive
            ? ResponsiveUtils.getResponsiveFontSize(
                context,
                AppDimensions.fontLarge,
              )
            : AppDimensions.fontLarge,
        color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      isResponsive: false, // Already handled above
    );
  }
} 