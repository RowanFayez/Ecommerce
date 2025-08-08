import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../data/models/product.dart';

class ResponsiveProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ResponsiveProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardHeight = ResponsiveUtils.getCardHeight(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.productBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: AppDimensions.blurRadiusMedium,
              offset: const Offset(0, AppDimensions.elevationLow),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Hero Animation
            Expanded(flex: 3, child: _buildProductImage()),

            // Product Details
            Expanded(flex: 2, child: _buildProductDetails(context, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusLarge),
      ),
      child: Hero(
        tag: 'product-image-${product.id}',
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.productImagePlaceholder,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusLarge),
            ),
          ),
          child: Image.network(
            product.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.productImagePlaceholder,
              child: const Icon(
                Icons.image_not_supported,
                size: AppDimensions.iconXLarge,
                color: AppColors.textLight,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                AppDimensions.fontLarge,
              ),
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.textPrimary,
            ),
          ),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),

          // Product Description
          Expanded(
            child: Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  AppDimensions.fontSmall,
                ),
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),

          // Rating and Price Row
          _buildRatingAndPriceRow(context, isDark),
        ],
      ),
    );
  }

  Widget _buildRatingAndPriceRow(BuildContext context, bool isDark) {
    return Row(
      children: [
        // Rating
        if (product.rating.rate > 0) ...[
          Icon(
            Icons.star,
            size: ResponsiveUtils.getResponsiveIconSize(
              context,
              AppDimensions.iconSmall,
            ),
            color: AppColors.ratingYellow,
          ),
          const SizedBox(width: 2),
          Text(
            product.rating.rate.toStringAsFixed(1),
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                AppDimensions.fontSmall,
              ),
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const Spacer(),
        ],

        // Price
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(
              context,
              AppDimensions.fontLarge,
            ),
            fontWeight: FontWeight.w600,
            color: AppColors.productPrice,
          ),
        ),
      ],
    );
  }
}
