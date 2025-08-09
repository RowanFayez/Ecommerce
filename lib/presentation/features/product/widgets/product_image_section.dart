import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:taskaia/data/models/product.dart';
import 'notched_bottom_clipper.dart';

class ProductImageSection extends StatelessWidget {
  final Product product;

  const ProductImageSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notchRadius = ResponsiveUtils.getResponsiveSpacing(context, 32);
    final cartButtonSize = ResponsiveUtils.getResponsiveSpacing(context, 48);

    return Stack(
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
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
      ],
    );
  }
}

