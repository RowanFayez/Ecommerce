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

// Category Filter Bar Widget
class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  final Map<String, IconData>? categoryIcons;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.categoryIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveUtils.getResponsiveSpacing(context, 60),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing16),
        ),
        children: [
          // "All" category chip
          CategoryChip(
            label: 'All',
            isSelected: selectedCategory == null,
            onTap: () => onCategorySelected(null),
            icon: Icons.apps,
          ),

          // Category chips
          ...categories.map((category) {
            return CategoryChip(
              label: _formatCategoryName(category),
              isSelected: selectedCategory == category,
              onTap: () => onCategorySelected(category),
              icon: categoryIcons?[category],
            );
          }),
        ],
      ),
    );
  }

  String _formatCategoryName(String category) {
    // Capitalize first letter and format category names
    return category.split(' ').map((word) {
      return word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : word;
    }).join(' ');
  }
}

// Search Bar Widget
class ProductSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onFilterPressed;
  final Function(String)? onChanged;

  const ProductSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'What are you looking for...',
    this.onFilterPressed,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(
            context, AppDimensions.spacing16),
        vertical: ResponsiveUtils.getResponsiveSpacing(
            context, AppDimensions.spacing8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getResponsiveSpacing(
                      context, AppDimensions.radiusMedium),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isDark ? AppColors.darkBorder : AppColors.cardShadow)
                            .withOpacity(0.1),
                    blurRadius:
                        ResponsiveUtils.getResponsiveSpacing(context, 8),
                    offset: Offset(
                        0, ResponsiveUtils.getResponsiveSpacing(context, 2)),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    AppDimensions.fontMedium,
                  ),
                  color: isDark ? AppColors.darkText : AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      AppDimensions.fontMedium,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    size: ResponsiveUtils.getResponsiveSpacing(
                        context, AppDimensions.iconMedium),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsiveSpacing(
                        context, AppDimensions.spacing16),
                    vertical: ResponsiveUtils.getResponsiveSpacing(
                        context, AppDimensions.spacing12),
                  ),
                ),
              ),
            ),
          ),
          if (onFilterPressed != null) ...[
            SizedBox(
                width: ResponsiveUtils.getResponsiveSpacing(
                    context, AppDimensions.spacing12)),
            GestureDetector(
              onTap: onFilterPressed,
              child: Container(
                width: ResponsiveUtils.getResponsiveSpacing(context, 48),
                height: ResponsiveUtils.getResponsiveSpacing(context, 48),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.getResponsiveSpacing(
                        context, AppDimensions.radiusMedium),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius:
                          ResponsiveUtils.getResponsiveSpacing(context, 8),
                      offset: Offset(
                          0, ResponsiveUtils.getResponsiveSpacing(context, 2)),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.tune,
                  color: AppColors.white,
                  size: ResponsiveUtils.getResponsiveSpacing(
                      context, AppDimensions.iconMedium),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
