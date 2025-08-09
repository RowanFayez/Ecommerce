import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';

class PromotionalContent extends StatelessWidget {
  final bool isDark;

  const PromotionalContent({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            height: ResponsiveUtils.getResponsiveSpacing(context, 4),
          ),

          // Main promotional text
          Flexible(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'Get 40% Off\nfor all items',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    ResponsiveUtils.isMobile(context)
                        ? AppDimensions.fontXLarge
                        : AppDimensions.fontHeading,
                  ),
                  color: isDark ? AppColors.darkText : AppColors.black,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
                maxLines: 2,
              ),
            ),
          ),

          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(context, 12),
          ),

          // Shop Now Button
          Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveUtils.isMobile(context) ? 100 : 120,
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
                        ResponsiveUtils.getResponsiveSpacing(context, 8),
                    vertical: ResponsiveUtils.getResponsiveSpacing(context, 6),
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
                        width: ResponsiveUtils.getResponsiveSpacing(context, 4),
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
    );
  }
}

