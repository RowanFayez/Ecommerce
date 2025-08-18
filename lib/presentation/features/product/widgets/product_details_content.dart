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
          LayoutBuilder(builder: (context, c) {
            final maxTitle = MediaQuery.of(context).size.width < 360 ?
              AppDimensions.fontHeading : AppDimensions.fontDisplay;
            return Text(
              product.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  maxTitle,
                ),
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
              ),
            );
          }),

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

          // Description section (no internal Expanded to avoid overflows)
          Text(
            'Description:',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                AppDimensions.fontXLarge,
              ),
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.textPrimary,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(
              context,
              AppDimensions.spacing8,
            ),
          ),
          Text(
            product.description,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                AppDimensions.fontLarge,
              ),
              height: 1.5,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            textAlign: TextAlign.start,
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
