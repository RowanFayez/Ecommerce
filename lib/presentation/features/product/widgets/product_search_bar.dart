import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';

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

