import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:taskaia/data/models/product.dart';
import '../../cart/cart_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.productBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: AppDimensions.blurRadiusMedium,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image with Hero Animation
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppDimensions.radiusLarge),
                        ),
                        child: Hero(
                          tag: 'product-image-${product.id}',
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.productImagePlaceholder,
                            ),
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: AppColors.productImagePlaceholder,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: AppDimensions.iconXLarge,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Heart Icon - Top Right
                      Positioned(
                        top: ResponsiveUtils.getResponsiveSpacing(context, 12),
                        right:
                            ResponsiveUtils.getResponsiveSpacing(context, 12),
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Add to favorites functionality
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                                ResponsiveUtils.getResponsiveSpacing(
                                    context, 8)),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.95),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cardShadow,
                                  blurRadius: AppDimensions.blurRadiusSmall,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.favorite_border,
                              size: ResponsiveUtils.getResponsiveIconSize(
                                context,
                                AppDimensions.iconSmall,
                              ),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Product Details
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacing12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product Name
                        Flexible(
                          child: Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: AppDimensions.fontLarge,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.textPrimary,
                              height: 1.2,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppDimensions.spacing4),

                        // Rating and Price Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Rating
                            if (product.rating.rate > 0)
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: AppDimensions.iconSmall,
                                      color: AppColors.ratingYellow,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      product.rating.rate.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: AppDimensions.fontSmall,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              const SizedBox(),

                            // Price
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: AppDimensions.fontLarge,
                                fontWeight: FontWeight.w600,
                                color: AppColors.productPrice,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Floating Cart Icon - Positioned at the very bottom center, overlapping the card
            Positioned(
              bottom: -ResponsiveUtils.getResponsiveSpacing(
                  context, 8), // Negative to overlap
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to cart screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CartScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(
                        ResponsiveUtils.getResponsiveSpacing(context, 12)),
                    decoration: BoxDecoration(
                      color:
                          AppColors.black, // Dark background like in the image
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardShadow.withOpacity(0.3),
                          blurRadius: AppDimensions.blurRadiusMedium,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.shopping_bag,
                      size: ResponsiveUtils.getResponsiveIconSize(
                        context,
                        AppDimensions.iconMedium,
                      ),
                      color: AppColors.white, // White icon like in the image
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
