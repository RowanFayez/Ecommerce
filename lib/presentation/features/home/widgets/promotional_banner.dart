import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'promotional_content.dart';

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: ResponsiveUtils.getHorizontalPadding(context),
      child: Container(
        height: ResponsiveUtils.getResponsiveSpacing(context, 160),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.darkSurface, AppColors.darkCard]
                : [AppColors.greyLight, AppColors.background],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withOpacity(0.15),
              blurRadius: AppDimensions.blurRadiusMedium,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            onTap: () {
              // TODO: Navigate to shop or promotional page
              print('Promotional banner tapped');
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              child: Row(
                children: [
                  // Left side - Text content
                  Expanded(
                    flex: ResponsiveUtils.isMobile(context) ? 3 : 2,
                    child: PromotionalContent(isDark: isDark),
                  ),

                  // Right side - Decorative elements
                  Expanded(
                    flex: ResponsiveUtils.isMobile(context) ? 2 : 1,
                    child: _buildDecorativeElements(context, isDark),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeElements(BuildContext context, bool isDark) {
    return Stack(
      children: [
        // Background decorative circles
        Positioned(
          top: -20,
          right: -20,
          child: Container(
            width: ResponsiveUtils.getResponsiveSpacing(context, 80),
            height: ResponsiveUtils.getResponsiveSpacing(context, 80),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -10,
          right: 20,
          child: Container(
            width: ResponsiveUtils.getResponsiveSpacing(context, 40),
            height: ResponsiveUtils.getResponsiveSpacing(context, 40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.infoBlue.withOpacity(0.15),
            ),
          ),
        ),

        // Shopping bag icon
        Positioned(
          top: ResponsiveUtils.getResponsiveSpacing(context, 20),
          right: ResponsiveUtils.getResponsiveSpacing(context, 20),
          child: Container(
            width: ResponsiveUtils.getResponsiveSpacing(context, 60),
            height: ResponsiveUtils.getResponsiveSpacing(context, 60),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: ResponsiveUtils.getResponsiveSpacing(context, 32),
              color: AppColors.primary,
            ),
          ),
        ),

        // Discount badge
        Positioned(
          bottom: ResponsiveUtils.getResponsiveSpacing(context, 20),
          right: ResponsiveUtils.getResponsiveSpacing(context, 20),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context, 12),
              vertical: ResponsiveUtils.getResponsiveSpacing(context, 6),
            ),
            decoration: BoxDecoration(
              color: AppColors.successGreen,
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.getResponsiveSpacing(context, 20),
              ),
            ),
            child: Text(
              '40% OFF',
              style: TextStyle(
                color: AppColors.white,
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  AppDimensions.fontSmall,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
