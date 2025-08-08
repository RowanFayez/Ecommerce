import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/responsive_utils.dart';

/// A reusable loading widget that provides consistent loading states throughout the app
class AppLoading extends StatelessWidget {
  final double? size;
  final Color? color;
  final bool isResponsive;
  final String? message;
  final bool showMessage;

  const AppLoading({
    super.key,
    this.size,
    this.color,
    this.isResponsive = true,
    this.message,
    this.showMessage = false,
  });

  /// Predefined loading sizes for common use cases
  const AppLoading.small({
    super.key,
    this.color,
    this.isResponsive = true,
    this.message,
    this.showMessage = false,
  })  : size = AppDimensions.iconSmall,
        super();

  const AppLoading.medium({
    super.key,
    this.color,
    this.isResponsive = true,
    this.message,
    this.showMessage = false,
  })  : size = AppDimensions.iconMedium,
        super();

  const AppLoading.large({
    super.key,
    this.color,
    this.isResponsive = true,
    this.message,
    this.showMessage = false,
  })  : size = AppDimensions.iconLarge,
        super();

  const AppLoading.xlarge({
    super.key,
    this.color,
    this.isResponsive = true,
    this.message,
    this.showMessage = false,
  })  : size = AppDimensions.iconXLarge,
        super();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final loadingSize = isResponsive && size != null
        ? ResponsiveUtils.getResponsiveIconSize(context, size!)
        : size ?? AppDimensions.iconMedium;

    final loadingColor = color ?? AppColors.primary;

    final loadingWidget = SizedBox(
      width: loadingSize,
      height: loadingSize,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
      ),
    );

    if (showMessage && message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingWidget,
          SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(
                  context, AppDimensions.spacing8)),
          Text(
            message!,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context, AppDimensions.fontMedium),
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return loadingWidget;
  }
}

/// A reusable loading overlay widget
class AppLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;
  final Color? overlayColor;
  final double? loadingSize;

  const AppLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.overlayColor,
    this.loadingSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? AppColors.dialogOverlay,
            child: Center(
              child: AppLoading.large(
                message: message,
                showMessage: message != null,
              ),
            ),
          ),
      ],
    );
  }
}

/// A reusable loading button widget
class AppLoadingButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? borderRadius;
  final EdgeInsets? padding;
  final IconData? icon;
  final bool isOutlined;

  const AppLoadingButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.borderRadius,
    this.padding,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = onPressed != null && !isLoading;

    final buttonHeight = height ?? ResponsiveUtils.getButtonHeight(context);
    final buttonWidth = isFullWidth ? double.infinity : null;
    final buttonBorderRadius = borderRadius ?? AppDimensions.radiusMedium;
    final buttonPadding = padding ??
        EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing24),
          vertical: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing12),
        );

    final defaultBackgroundColor = isOutlined
        ? Colors.transparent
        : (backgroundColor ?? AppColors.primary);
    final defaultTextColor = isOutlined
        ? (textColor ?? AppColors.primary)
        : (textColor ?? AppColors.textOnPrimary);

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultBackgroundColor,
          foregroundColor: defaultTextColor,
          disabledBackgroundColor:
              isDark ? AppColors.darkBorder : AppColors.greyLight,
          disabledForegroundColor:
              isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
          padding: buttonPadding,
          elevation: isOutlined ? 0 : AppDimensions.elevationLow,
          side: isOutlined
              ? BorderSide(
                  color: AppColors.primary,
                  width: 1.0,
                )
              : null,
        ),
        child: isLoading
            ? SizedBox(
                width: ResponsiveUtils.getResponsiveIconSize(
                    context, AppDimensions.iconSmall),
                height: ResponsiveUtils.getResponsiveIconSize(
                    context, AppDimensions.iconSmall),
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(defaultTextColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: ResponsiveUtils.getResponsiveIconSize(
                          context, AppDimensions.iconSmall),
                    ),
                    SizedBox(
                        width: ResponsiveUtils.getResponsiveSpacing(
                            context, AppDimensions.spacing8)),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context, AppDimensions.fontMedium),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
