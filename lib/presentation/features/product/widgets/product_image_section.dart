import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:taskaia/data/models/product.dart';
import 'notched_bottom_clipper.dart';

class ProductImageSection extends StatelessWidget {
  final Product product;
  final VoidCallback? onCartPressed;

  const ProductImageSection({
    super.key,
    required this.product,
    this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notchRadius = ResponsiveUtils.getResponsiveSpacing(context, 28);
    final cartInnerSize = ResponsiveUtils.getResponsiveSpacing(context, 32);
    final cornerRadius = ResponsiveUtils.getResponsiveSpacing(
        context, AppDimensions.radiusLarge);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Product Image with Custom Clipper that subtracts a bottom-center hill/oval
        ClipPath(
          clipper: NotchedBottomClipper(
            cornerRadius: cornerRadius,
            notchRadius: notchRadius,
            notchVerticalOverflow:
                ResponsiveUtils.getResponsiveSpacing(context, 10),
            horizontalRadiusFactor: 1.4,
          ),
          child: SizedBox.expand(
            child: Hero(
              tag: 'product-image-${product.id}',
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.productImagePlaceholder,
                    child: Center(
                      child: SizedBox(
                        width: ResponsiveUtils.getResponsiveSpacing(
                            context, AppDimensions.iconMedium),
                        height: ResponsiveUtils.getResponsiveSpacing(
                            context, AppDimensions.iconMedium),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.productImagePlaceholder,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: ResponsiveUtils.getResponsiveSpacing(
                        context, AppDimensions.iconXLarge),
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textLight,
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
            width: ResponsiveUtils.getResponsiveSpacing(context, 36),
            height: ResponsiveUtils.getResponsiveSpacing(context, 36),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkCard : AppColors.white)
                  .withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow.withOpacity(0.2),
                  blurRadius: ResponsiveUtils.getResponsiveSpacing(context, 8),
                  offset: Offset(
                      0, ResponsiveUtils.getResponsiveSpacing(context, 2)),
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
        // Small dark cart icon centered inside the notch, overlapping image + card
        Positioned(
          bottom: -ResponsiveUtils.getResponsiveSpacing(
              context, (cartInnerSize / 2) - 2),
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: onCartPressed ?? () => _handleAddToCart(context),
              child: Container(
                width: cartInnerSize,
                height: cartInnerSize,
                decoration: BoxDecoration(
                  color: AppColors.cartButtonBackground,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow.withOpacity(0.35),
                      blurRadius:
                          ResponsiveUtils.getResponsiveSpacing(context, 8),
                      offset: Offset(
                          0, ResponsiveUtils.getResponsiveSpacing(context, 3)),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.white,
                  size: ResponsiveUtils.getResponsiveSpacing(
                      context, cartInnerSize * 0.45),
                ),
              ),
            ),
          ),
        ),
      ],
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
