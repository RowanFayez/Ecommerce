import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: ResponsiveUtils.getHorizontalPadding(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Welcome text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      AppDimensions.fontMedium,
                    ),
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(
                    context,
                    AppDimensions.spacing4,
                  ),
                ),
                Text(
                  'Falcon Thought',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      AppDimensions.fontHeading,
                    ),
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.black,
                  ),
                ),
              ],
            ),
          ),

          // Right side - Shopping bag icon
          Container(
            padding: EdgeInsets.all(
                ResponsiveUtils.getResponsiveSpacing(context, 8)),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.shopping_bag,
              size: ResponsiveUtils.getResponsiveIconSize(
                context,
                AppDimensions.iconMedium,
              ),
              color: isDark ? AppColors.darkText : AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
