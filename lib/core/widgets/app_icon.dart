import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/responsive_utils.dart';

/// A reusable icon widget that provides consistent icon styling throughout the app
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final bool isResponsive;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isButton;

  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.isResponsive = true,
    this.onPressed,
    this.tooltip,
    this.isButton = false,
  });

  /// Predefined icon sizes for common use cases
  const AppIcon.small(
    this.icon, {
    super.key,
    this.color,
    this.isResponsive = true,
    this.onPressed,
    this.tooltip,
    this.isButton = false,
  })  : size = AppDimensions.iconSmall,
        super();

  const AppIcon.medium(
    this.icon, {
    super.key,
    this.color,
    this.isResponsive = true,
    this.onPressed,
    this.tooltip,
    this.isButton = false,
  })  : size = AppDimensions.iconMedium,
        super();

  const AppIcon.large(
    this.icon, {
    super.key,
    this.color,
    this.isResponsive = true,
    this.onPressed,
    this.tooltip,
    this.isButton = false,
  })  : size = AppDimensions.iconLarge,
        super();

  const AppIcon.xlarge(
    this.icon, {
    super.key,
    this.color,
    this.isResponsive = true,
    this.onPressed,
    this.tooltip,
    this.isButton = false,
  })  : size = AppDimensions.iconXLarge,
        super();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconSize = isResponsive && size != null
        ? ResponsiveUtils.getResponsiveIconSize(context, size!)
        : size ?? AppDimensions.iconMedium;

    final iconColor =
        color ?? (isDark ? AppColors.darkText : AppColors.textPrimary);

    final iconWidget = Icon(
      icon,
      size: iconSize,
      color: iconColor,
    );

    if (isButton && onPressed != null) {
      return IconButton(
        icon: iconWidget,
        onPressed: onPressed,
        tooltip: tooltip,
        iconSize: iconSize,
      );
    }

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}

/// A reusable icon button widget
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final Color? backgroundColor;
  final bool isResponsive;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double? borderRadius;
  final EdgeInsets? padding;
  final bool isCircular;

  const AppIconButton(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.backgroundColor,
    this.isResponsive = true,
    this.onPressed,
    this.tooltip,
    this.borderRadius,
    this.padding,
    this.isCircular = false,
  });

  /// Predefined icon button styles for common use cases
  const AppIconButton.small(
    this.icon, {
    super.key,
    this.color,
    this.backgroundColor,
    this.isResponsive = true,
    this.onPressed,
    this.tooltip,
    this.borderRadius,
    this.padding,
    this.isCircular = false,
  })  : size = AppDimensions.iconSmall,
        super();

  const AppIconButton.medium(
    this.icon, {
    super.key,
    this.color,
    this.backgroundColor,
    this.isResponsive = true,
    this.onPressed,
    this.tooltip,
    this.borderRadius,
    this.padding,
    this.isCircular = false,
  })  : size = AppDimensions.iconMedium,
        super();

  const AppIconButton.large(
    this.icon, {
    super.key,
    this.color,
    this.backgroundColor,
    this.isResponsive = true,
    this.onPressed,
    this.tooltip,
    this.borderRadius,
    this.padding,
    this.isCircular = false,
  })  : size = AppDimensions.iconLarge,
        super();

  const AppIconButton.circular(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.backgroundColor,
    this.isResponsive = true,
    this.onPressed,
    this.tooltip,
    this.padding,
  })  : borderRadius = AppDimensions.radiusCircular,
        isCircular = true,
        super();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconSize = isResponsive && size != null
        ? ResponsiveUtils.getResponsiveIconSize(context, size!)
        : size ?? AppDimensions.iconMedium;

    final iconColor =
        color ?? (isDark ? AppColors.darkText : AppColors.textPrimary);
    final buttonColor =
        backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.white);
    final buttonBorderRadius = borderRadius ??
        (isCircular
            ? AppDimensions.radiusCircular
            : AppDimensions.radiusMedium);
    final buttonPadding = padding ??
        EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(
            context, AppDimensions.spacing8));

    return Container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(buttonBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: AppDimensions.blurRadiusSmall,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(buttonBorderRadius),
          child: Padding(
            padding: buttonPadding,
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
