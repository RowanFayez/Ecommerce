import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../data/models/product.dart';
import 'reusable_product_image.dart'; // Import the new reusable widget

class ProductDetailsHeader extends StatelessWidget {
  final Product product;

  const ProductDetailsHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Product Image using Reusable Widget - Fixed Overflow
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: ResponsiveUtils.getHorizontalPadding(context),
          child: ReusableProductImage(
            imageUrl: product.image,
            heroTag: 'product-image-${product.id}',
            aspectRatio: 1.2, // Fixed aspect ratio to prevent overflow
            borderRadius: AppDimensions.radiusLarge,
            fit: BoxFit.cover,
            showShadow: true,
          ),
        ),

        // Back Button
        Positioned(
          top: MediaQuery.of(context).padding.top + AppDimensions.spacing8,
          left: AppDimensions.spacing16,
          child: Container(
            margin: const EdgeInsets.all(AppDimensions.spacing8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: AppDimensions.blurRadiusSmall,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: AppDimensions.iconMedium,
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }
}
