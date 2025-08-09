import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:taskaia/data/models/product.dart';
import 'product_image_section.dart';
import 'product_info_section.dart';
import 'product_cart_button.dart';

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
    final cardHeight = ResponsiveUtils.getCardHeight(context) + 40;
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
            _buildMainCard(context, isDark, cardHeight),

            // Floating Cart Button
            ProductCartButton(
              product: product,
              cardHeight: cardHeight,
              cartButtonSize: cartButtonSize,
              onCartPressed: onCartPressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, bool isDark, double cardHeight) {
    return Container(
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
            offset: Offset(0, ResponsiveUtils.getResponsiveSpacing(context, 4)),
            spreadRadius: ResponsiveUtils.getResponsiveSpacing(context, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Product Image Section
          Expanded(
            flex: 3,
            child: ProductImageSection(product: product),
          ),

          // Product Info Section
          Expanded(
            flex: 2,
            child: ProductInfoSection(product: product),
          ),
        ],
      ),
    );
  }
}
