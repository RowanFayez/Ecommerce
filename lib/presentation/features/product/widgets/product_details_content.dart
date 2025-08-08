import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../data/models/product.dart';
import 'product_rating_widget.dart';

class ProductDetailsContent extends StatelessWidget {
  final Product product;

  const ProductDetailsContent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(
        context,
        AppDimensions.spacing24,
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
            context,
            AppDimensions.spacing20,
          )),

          // Product Name
          Text(
            product.title,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                AppDimensions.fontDisplay,
              ),
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.textPrimary,
            ),
          ),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
            context,
            AppDimensions.spacing12,
          )),

          // Rating and Reviews
          ProductRatingWidget(
            rating: product.rating.rate,
            reviewCount: product.rating.count,
          ),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
            context,
            AppDimensions.spacing16,
          )),

          // Product Description - Fixed: No Scroll, Auto-fit Text
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate available space and adjust text accordingly
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description:', // Optional header
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          AppDimensions.fontXLarge,
                        ),
                        fontWeight: FontWeight.w600,
                        color:
                            isDark ? AppColors.darkText : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                      context,
                      AppDimensions.spacing8,
                    )),
                    Expanded(
                      child: Text(
                        product.description,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            AppDimensions.fontLarge,
                          ),
                          height: 1.5, // Better line spacing
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.justify, // Better text alignment
                        overflow: TextOverflow
                            .visible, // Allow text to show completely
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
            context,
            AppDimensions.spacing20,
          )),
        ],
      ),
    );
  }
}
