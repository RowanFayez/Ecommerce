import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppDimensions.animationFast),
        margin: const EdgeInsets.only(right: AppDimensions.spacing12),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.chipSelectedDark
                  : AppColors.chipSelectedLight)
              : (isDark
                  ? AppColors.chipUnselectedDark
                  : AppColors.chipUnselectedLight),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark
                      ? AppColors.chipBorderDark
                      : AppColors.chipBorderLight,
                  width: 1,
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (isDark
                    ? AppColors.chipSelectedLight
                    : AppColors.chipSelectedDark)
                : (isDark
                    ? AppColors.chipTextUnselectedDark
                    : AppColors.chipTextUnselectedLight),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: AppDimensions.fontMedium,
          ),
        ),
      ),
    );
  }
}
