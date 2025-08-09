import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:taskaia/data/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onCartPressed;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardHeight =
        ResponsiveUtils.getCardHeight(context) + 40; // Extra height for notch
    final notchRadius = ResponsiveUtils.getResponsiveSpacing(context, 32);
    final cartButtonSize = ResponsiveUtils.getResponsiveSpacing(context, 48);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing8),
          vertical: ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing8),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main Card Container
            Container(
              width: double.infinity,
              height: cardHeight,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getResponsiveSpacing(
                      context, AppDimensions.radiusLarge),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? AppColors.darkBorder.withOpacity(0.3)
                        : AppColors.cardShadow.withOpacity(0.15),
                    blurRadius: ResponsiveUtils.getResponsiveSpacing(
                        context, AppDimensions.blurRadiusMedium),
                    offset: Offset(
                        0, ResponsiveUtils.getResponsiveSpacing(context, 4)),
                    spreadRadius:
                        ResponsiveUtils.getResponsiveSpacing(context, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Product Image Section with Notch
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        // Product Image with Custom Clipper for Notch
                        ClipPath(
                          clipper: NotchedBottomClipper(
                            notchRadius: notchRadius,
                            notchWidth: cartButtonSize + 16,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                ResponsiveUtils.getResponsiveSpacing(
                                    context, AppDimensions.radiusLarge),
                              ),
                              topRight: Radius.circular(
                                ResponsiveUtils.getResponsiveSpacing(
                                    context, AppDimensions.radiusLarge),
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Hero(
                                tag: 'product-image-${product.id}',
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: isDark
                                          ? AppColors.darkSurface
                                          : AppColors.productImagePlaceholder,
                                      child: Center(
                                        child: SizedBox(
                                          width: ResponsiveUtils
                                              .getResponsiveSpacing(context,
                                                  AppDimensions.iconMedium),
                                          height: ResponsiveUtils
                                              .getResponsiveSpacing(context,
                                                  AppDimensions.iconMedium),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppColors.primary),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: isDark
                                        ? AppColors.darkSurface
                                        : AppColors.productImagePlaceholder,
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size:
                                          ResponsiveUtils.getResponsiveSpacing(
                                              context,
                                              AppDimensions.iconXLarge),
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textLight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Favorite Button (Top Right)
                        Positioned(
                          top: ResponsiveUtils.getResponsiveSpacing(
                              context, AppDimensions.spacing12),
                          right: ResponsiveUtils.getResponsiveSpacing(
                              context, AppDimensions.spacing12),
                          child: Container(
                            width: ResponsiveUtils.getResponsiveSpacing(
                                context, 36),
                            height: ResponsiveUtils.getResponsiveSpacing(
                                context, 36),
                            decoration: BoxDecoration(
                              color: (isDark
                                      ? AppColors.darkCard
                                      : AppColors.white)
                                  .withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cardShadow.withOpacity(0.2),
                                  blurRadius:
                                      ResponsiveUtils.getResponsiveSpacing(
                                          context, 8),
                                  offset: Offset(
                                      0,
                                      ResponsiveUtils.getResponsiveSpacing(
                                          context, 2)),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.favorite_outline,
                              size: ResponsiveUtils.getResponsiveSpacing(
                                  context, AppDimensions.iconSmall),
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Product Info Section
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        ResponsiveUtils.getResponsiveSpacing(
                            context, AppDimensions.spacing16),
                        ResponsiveUtils.getResponsiveSpacing(
                            context, AppDimensions.spacing16),
                        ResponsiveUtils.getResponsiveSpacing(
                            context, AppDimensions.spacing16),
                        ResponsiveUtils.getResponsiveSpacing(
                            context, AppDimensions.spacing12),
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
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.textPrimary,
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
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
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
                                      size:
                                          ResponsiveUtils.getResponsiveSpacing(
                                              context, AppDimensions.iconSmall),
                                      color: AppColors.ratingYellow,
                                    ),
                                    SizedBox(
                                        width: ResponsiveUtils
                                            .getResponsiveSpacing(context, 2)),
                                    Text(
                                      product.rating.rate.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils
                                            .getResponsiveFontSize(
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
                    ),
                  ),
                ],
              ),
            ),

            // Floating Cart Button
            Positioned(
              bottom: ResponsiveUtils.getResponsiveSpacing(
                  context, cardHeight * 0.32),
              right: ResponsiveUtils.getResponsiveSpacing(
                  context, AppDimensions.spacing20),
              child: GestureDetector(
                onTap: onCartPressed ?? () => _handleAddToCart(context),
                child: Container(
                  width: cartButtonSize,
                  height: cartButtonSize,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius:
                            ResponsiveUtils.getResponsiveSpacing(context, 12),
                        offset: Offset(0,
                            ResponsiveUtils.getResponsiveSpacing(context, 4)),
                        spreadRadius:
                            ResponsiveUtils.getResponsiveSpacing(context, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.white,
                    size: ResponsiveUtils.getResponsiveSpacing(
                        context, cartButtonSize * 0.45),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddToCart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppColors.white,
              size: ResponsiveUtils.getResponsiveSpacing(
                  context, AppDimensions.iconSmall),
            ),
            SizedBox(
                width: ResponsiveUtils.getResponsiveSpacing(
                    context, AppDimensions.spacing8)),
            Expanded(
              child: Text(
                '${product.title} added to cart!',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    AppDimensions.fontMedium,
                  ),
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
            ResponsiveUtils.getResponsiveSpacing(
                context, AppDimensions.radiusMedium),
          ),
        ),
        margin: EdgeInsets.all(
          ResponsiveUtils.getResponsiveSpacing(
              context, AppDimensions.spacing16),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Custom Clipper for creating the notch at the bottom of the image
class NotchedBottomClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double notchWidth;

  NotchedBottomClipper({
    required this.notchRadius,
    required this.notchWidth,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width - (notchWidth / 2) - 20; // Position from right
    final notchCenterY = size.height;

    // Start from top left
    path.moveTo(0, 0);

    // Top edge
    path.lineTo(size.width, 0);

    // Right edge down to notch start
    path.lineTo(size.width, notchCenterY);

    // Bottom edge to notch start
    path.lineTo(centerX + (notchWidth / 2), notchCenterY);

    // Create smooth notch curve
    path.quadraticBezierTo(
      centerX,
      notchCenterY - notchRadius,
      centerX - (notchWidth / 2),
      notchCenterY,
    );

    // Continue bottom edge
    path.lineTo(0, notchCenterY);

    // Left edge up
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
