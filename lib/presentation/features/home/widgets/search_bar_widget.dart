import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: ResponsiveUtils.getHorizontalPadding(context),
      child: Container(
        height: ResponsiveUtils.getResponsiveSpacing(context, 56),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.background,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withOpacity(0.1),
              blurRadius: AppDimensions.blurRadiusSmall,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onSubmitted: onSearch,
          decoration: InputDecoration(
            hintText: 'What are you looking for...',
            hintStyle: TextStyle(
              fontSize: AppDimensions.fontMedium,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              size: AppDimensions.iconMedium,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
              vertical: ResponsiveUtils.getResponsiveSpacing(context, 12),
            ),
          ),
          style: TextStyle(
            fontSize: AppDimensions.fontMedium,
            color: isDark ? AppColors.darkText : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
