import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:taskaia/data/models/product.dart';
import '../../../../core/widgets/floating_cart_button.dart';
import '../../../../core/widgets/notched_background_painter.dart';

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
        margin: EdgeInsets.only(
          bottom: ResponsiveUtils.getResponsiveSpacing(context, 12),
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.productBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withOpacity(0.1),
              blurRadius: AppDimensions.blurRadiusMedium,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: Column(
            children: [
              // Image
              Expanded(
                flex: 3,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      color: AppColors.productImagePlaceholder,
                      child: Hero(
                        tag: 'product-image-${product.id}',
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: AppColors.productImagePlaceholder,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: AppColors.primary,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
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

                    // Favorite Icon
                    Positioned(
                      top: ResponsiveUtils.getResponsiveSpacing(context, 12),
                      right: ResponsiveUtils.getResponsiveSpacing(context, 12),
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Add to favorites functionality
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                              ResponsiveUtils.getResponsiveSpacing(context, 8)),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.95),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cardShadow.withOpacity(0.2),
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

              // Info section with notch + cart icon
              Expanded(
                flex: 2,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // White background with notch
                    Positioned.fill(
                      child: CustomPaint(
                        painter: NotchedBackgroundPainter(notchRadius: 28),
                      ),
                    ),

                    // Cart icon above notch
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(0, -24),
                          child: FloatingCartButton(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle,
                                          color: AppColors.white,
                                          size: AppDimensions.iconSmall),
                                      const SizedBox(
                                          width: AppDimensions.spacing8),
                                      Expanded(
                                        child: Text(
                                          '${product.title} added to cart!',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: AppDimensions.fontMedium,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: AppColors.successGreen,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusSmall),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  margin:
                                      EdgeInsets.all(AppDimensions.spacing16),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Product details
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppDimensions.spacing16,
                        AppDimensions.spacing28,
                        AppDimensions.spacing16,
                        AppDimensions.spacing20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
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
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.textPrimary,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                    context,
                                    AppDimensions.fontXLarge,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              if (product.rating.rate > 0)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: AppDimensions.spacing4,
                                  ),
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
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
