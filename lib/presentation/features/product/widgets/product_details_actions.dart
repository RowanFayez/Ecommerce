import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../data/models/product.dart';

class ProductDetailsActions extends StatelessWidget {
  final Product product;

  const ProductDetailsActions({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(
        context,
        AppDimensions.spacing24,
      )),
      child: Row(
        children: [
          // Price Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.price, // Changed from hardcoded 'Price'
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    AppDimensions.fontMedium,
                  ),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    AppDimensions.fontHeading,
                  ),
                  fontWeight: FontWeight.bold,
                  color: AppColors.productPrice,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Add to Cart Button
          ElevatedButton(
            onPressed: product.isAvailable ? () => _addToCart(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.textLight,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  AppDimensions.spacing32,
                ),
                vertical: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  AppDimensions.spacing16,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
            ),
            child: Text(
              product.isAvailable
                  ? AppStrings.addToCart
                  : AppStrings.outOfStock, // Changed from hardcoded strings
              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  AppDimensions.fontLarge,
                ),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${product.title} ${AppStrings.addedToCart}',
        ), // Changed from hardcoded string
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
      ),
    );
  }
}
