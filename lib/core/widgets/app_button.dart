import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/responsive_utils.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsets? padding;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool isOutlined;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = onPressed != null && !isLoading;

    final buttonHeight = height ?? ResponsiveUtils.getButtonHeight(context);
    final buttonWidth = isFullWidth ? double.infinity : width;
    final buttonBorderRadius = borderRadius ?? AppDimensions.radiusMedium;
    final buttonPadding =
        padding ??
        const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing24,
          vertical: AppDimensions.spacing12,
        );

    final defaultBackgroundColor = isOutlined
        ? Colors.transparent
        : (backgroundColor ?? AppColors.primary);
    final defaultTextColor = isOutlined
        ? (backgroundColor ?? AppColors.primary)
        : (textColor ?? AppColors.textOnPrimary);
    final defaultDisabledBackgroundColor = isOutlined
        ? Colors.transparent
        : (disabledBackgroundColor ?? AppColors.textLight);
    final defaultDisabledTextColor = isOutlined
        ? AppColors.textLight
        : (disabledTextColor ?? AppColors.textOnPrimary);

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? defaultBackgroundColor
              : defaultDisabledBackgroundColor,
          foregroundColor: isEnabled
              ? defaultTextColor
              : defaultDisabledTextColor,
          disabledBackgroundColor: defaultDisabledBackgroundColor,
          disabledForegroundColor: defaultDisabledTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
            side: isOutlined
                ? BorderSide(
                    color: isEnabled
                        ? (backgroundColor ?? AppColors.primary)
                        : AppColors.textLight,
                    width: 1.5,
                  )
                : BorderSide.none,
          ),
          padding: buttonPadding,
          elevation: isOutlined ? 0 : AppDimensions.elevationMedium,
        ),
        child: isLoading
            ? SizedBox(
                width: AppDimensions.iconMedium,
                height: AppDimensions.iconMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(defaultTextColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppDimensions.iconMedium),
                    SizedBox(width: AppDimensions.spacing8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: AppDimensions.fontLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
