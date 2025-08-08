import 'package:flutter/material.dart';
import '../../../../data/models/product.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../product/widgets/product_card.dart';

class StaggeredProductsGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;

  const StaggeredProductsGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: ResponsiveUtils.getHorizontalPadding(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = ResponsiveUtils.getGridCrossAxisCount(context);
          final spacing = ResponsiveUtils.getResponsiveSpacing(
            context,
            AppDimensions.gridSpacing,
          );

          // Calculate item width accounting for spacing
          final totalSpacing = spacing * (crossAxisCount - 1);
          final availableWidth = constraints.maxWidth - totalSpacing;
          final itemWidth = availableWidth / crossAxisCount;

          // Calculate aspect ratio to ensure proper height for the cart icon
          final aspectRatio = ResponsiveUtils.isMobile(context) ? 0.75 : 0.8;
          final itemHeight = itemWidth / aspectRatio;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: aspectRatio,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => onProductTap(product),
              );
            },
          );
        },
      ),
    );
  }
}

// Alternative implementation with different heights for variety
class VariedHeightProductsGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;

  const VariedHeightProductsGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: ResponsiveUtils.getHorizontalPadding(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = ResponsiveUtils.getGridCrossAxisCount(context);
          final spacing = ResponsiveUtils.getResponsiveSpacing(
            context,
            AppDimensions.gridSpacing,
          );

          return CustomScrollView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.75, // Consistent aspect ratio
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => onProductTap(product),
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
