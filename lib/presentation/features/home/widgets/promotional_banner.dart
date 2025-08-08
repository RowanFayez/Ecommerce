import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = ResponsiveUtils.getScreenWidth(context);

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
                  // Left side - Text content (Fixed width to prevent overflow)
                  Expanded(
                    flex: ResponsiveUtils.isMobile(context) ? 3 : 2,
                    child: Padding(
                      padding: EdgeInsets.all(
                        ResponsiveUtils.getResponsiveSpacing(context, 16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Smaller top text
                          Flexible(
                            child: Text(
                              'Shop with us!',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.getResponsiveFontSize(
                                  context,
                                  AppDimensions.fontSmall,
                                ),
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                                context, 4),
                          ),

                          // Main promotional text (Fixed to prevent overflow)
                          Flexible(
                            flex: 2,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Get 40% Off\nfor all items',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                    context,
                                    ResponsiveUtils.isMobile(context)
                                        ? AppDimensions.fontXLarge
                                        : AppDimensions.fontHeading,
                                  ),
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                                context, 12),
                          ),

                          // Shop Now Button (Fixed container to prevent overflow)
                          Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  ResponsiveUtils.isMobile(context) ? 100 : 120,
                              minHeight: 32,
                            ),
                            child: Material(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMedium,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMedium,
                                ),
                                onTap: () {
                                  // TODO: Navigate to shop
                                  print('Shop Now tapped');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        ResponsiveUtils.getResponsiveSpacing(
                                      context,
                                      8,
                                    ),
                                    vertical:
                                        ResponsiveUtils.getResponsiveSpacing(
                                      context,
                                      6,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Shop Now',
                                          style: TextStyle(
                                            fontSize: AppDimensions.fontSmall,
                                            color: AppColors.textOnPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        width: ResponsiveUtils
                                            .getResponsiveSpacing(
                                          context,
                                          4,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: AppDimensions.iconSmall,
                                        color: AppColors.textOnPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right side - Image placeholder (Fixed to prevent overflow)
                  Expanded(
                    flex: ResponsiveUtils.isMobile(context) ? 2 : 2,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(AppDimensions.radiusLarge),
                          bottomRight:
                              Radius.circular(AppDimensions.radiusLarge),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.productImagePlaceholder,
                            AppColors.productImagePlaceholder.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                ResponsiveUtils.getResponsiveSpacing(
                                    context, 8),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: ResponsiveUtils.getResponsiveSpacing(
                                  context,
                                  ResponsiveUtils.isMobile(context) ? 24 : 32,
                                ),
                                color: AppColors.textLight,
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveUtils.getResponsiveSpacing(
                                  context, 4),
                            ),
                            Flexible(
                              child: Text(
                                'Man in Suit\nImage',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppDimensions.fontSmall,
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
