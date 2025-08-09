import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppDimensions.animationMedium),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          right: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing12),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing20),
          vertical: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing12),
        ),
        decoration: BoxDecoration(
          color: _getBackgroundColor(isDark),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveSpacing(
                context, AppDimensions.radiusCircular),
          ),
          border: isSelected
              ? null
              : Border.all(
                  color: _getBorderColor(isDark),
                  width: ResponsiveUtils.getResponsiveSpacing(context, 1),
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius:
                        ResponsiveUtils.getResponsiveSpacing(context, 8),
                    offset: Offset(
                        0, ResponsiveUtils.getResponsiveSpacing(context, 2)),
                  ),
                ]
              : [
                  BoxShadow(
                    color:
                        (isDark ? AppColors.darkBorder : AppColors.cardShadow)
                            .withOpacity(0.1),
                    blurRadius:
                        ResponsiveUtils.getResponsiveSpacing(context, 4),
                    offset: Offset(
                        0, ResponsiveUtils.getResponsiveSpacing(context, 1)),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: ResponsiveUtils.getResponsiveSpacing(
                    context, AppDimensions.iconSmall),
                color: _getTextColor(isDark),
              ),
              SizedBox(
                  width: ResponsiveUtils.getResponsiveSpacing(
                      context, AppDimensions.spacing8)),
            ],
            Text(
              label,
              style: TextStyle(
                color: _getTextColor(isDark),
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  AppDimensions.fontMedium,
                ),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isDark) {
    if (isSelected) {
      return AppColors.primary;
    }
    return isDark ? AppColors.darkCard : AppColors.white;
  }

  Color _getBorderColor(bool isDark) {
    return isDark
        ? AppColors.darkBorder.withOpacity(0.5)
        : AppColors.borderLight.withOpacity(0.6);
  }

  Color _getTextColor(bool isDark) {
    if (isSelected) {
      return AppColors.white;
    }
    return isDark ? AppColors.darkText : AppColors.textPrimary;
  }
}
