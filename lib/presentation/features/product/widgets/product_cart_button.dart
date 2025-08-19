import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:taskaia/data/models/product.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/hive/cart_local_cache.dart';
import '../../../../data/models/cart_item_hive.dart';

class ProductCartButton extends StatelessWidget {
  final Product product;
  final double cardHeight;
  final double cartButtonSize;
  final VoidCallback? onCartPressed;

  const ProductCartButton({
    super.key,
    required this.product,
    required this.cardHeight,
    required this.cartButtonSize,
    this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: ResponsiveUtils.getResponsiveSpacing(context, cardHeight * 0.32),
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
                blurRadius: ResponsiveUtils.getResponsiveSpacing(context, 12),
                offset:
                    Offset(0, ResponsiveUtils.getResponsiveSpacing(context, 4)),
                spreadRadius: ResponsiveUtils.getResponsiveSpacing(context, 2),
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
    );
  }

  void _handleAddToCart(BuildContext context) {
    // Persist locally
    try {
      final cache = getIt<CartLocalCache>();
      final existing = cache
          .getItems()
          .firstWhere((e) => e.productId == product.id, orElse: () => CartItemHive(
                productId: product.id,
                title: product.title,
                imageUrl: product.image,
                price: product.price,
                quantity: 0,
                sizeLabel: 'M',
              ));
      final nextQty = (existing.quantity) + 1;
      cache.upsertItem(existing.copyWith(quantity: nextQty));
    } catch (_) {}

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

