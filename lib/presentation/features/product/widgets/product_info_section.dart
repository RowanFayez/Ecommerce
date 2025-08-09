import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:taskaia/data/models/product.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;

  const ProductInfoSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.getResponsiveSpacing(context, AppDimensions.spacing16),
        ResponsiveUtils.getResponsiveSpacing(context, AppDimensions.spacing16),
        ResponsiveUtils.getResponsiveSpacing(context, AppDimensions.spacing16),
        ResponsiveUtils.getResponsiveSpacing(context, AppDimensions.spacing12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Product Title
          Expanded(
            child: Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  AppDimensions.fontLarge,
                ),
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ),

          SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(
                  context, AppDimensions.spacing8)),

          // Price and Rating Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Price
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    AppDimensions.fontXLarge,
                  ),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              // Rating
              if (product.rating.rate > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: ResponsiveUtils.getResponsiveSpacing(
                          context, AppDimensions.iconSmall),
                      color: AppColors.ratingYellow,
                    ),
                    SizedBox(
                        width:
                            ResponsiveUtils.getResponsiveSpacing(context, 2)),
                    Text(
                      product.rating.rate.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          AppDimensions.fontSmall,
                        ),
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

