import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:taskaia/data/models/product.dart';
import '../../../../core/widgets/floating_cart_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

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
        child: Column(
          children: [
            // ======== IMAGE WITH NOTCH CUT ========
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                ClipPath(
                  clipper: NotchedImageClipper(
                    notchRadius:
                        ResponsiveUtils.getResponsiveSpacing(context, 28),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusLarge),
                      topRight: Radius.circular(AppDimensions.radiusLarge),
                    ),
                    child: Hero(
                      tag: 'product-image-${product.id}',
                      child: Image.network(
                        product.imageUrl,
                        height: 160,
                        width: double.infinity,
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
                        errorBuilder: (context, error, stackTrace) => Container(
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
                // Floating Cart Button on white notch
                Positioned(
                  bottom:
                      -ResponsiveUtils.getResponsiveSpacing(context, 28) / 2,
                  child: FloatingCartButton(
                    size: ResponsiveUtils.getResponsiveSpacing(context, 56),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: AppColors.white,
                                  size: AppDimensions.iconSmall),
                              const SizedBox(width: AppDimensions.spacing8),
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
                          margin: EdgeInsets.all(AppDimensions.spacing16),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // ======== INFO SECTION ========
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.spacing16,
                AppDimensions.spacing28,
                AppDimensions.spacing16,
                AppDimensions.spacing20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        AppDimensions.fontLarge,
                      ),
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppColors.darkText : AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        AppDimensions.fontXLarge,
                      ),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  if (product.rating.rate > 0)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: AppDimensions.spacing4),
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
            ),
          ],
        ),
      ),
    );
  }
}

// ======== CLIPPER FOR IMAGE WITH CENTER NOTCH ========
class NotchedImageClipper extends CustomClipper<Path> {
  final double notchRadius;

  NotchedImageClipper({required this.notchRadius});

  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;

    // Top left to bottom left
    path.moveTo(0, 0);
    path.lineTo(0, size.height);

    // Left side to notch start
    path.lineTo(centerX - notchRadius, size.height);

    // Notch curve
    path.arcToPoint(
      Offset(centerX + notchRadius, size.height),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Right side from notch to bottom right
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
