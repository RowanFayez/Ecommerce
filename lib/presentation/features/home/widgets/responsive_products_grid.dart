import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../data/models/product.dart';
import '../../product/widgets/product_card.dart';

class ResponsiveProductsGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final ScrollController? scrollController;

  const ResponsiveProductsGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: ResponsiveUtils.getHorizontalPadding(context),
        child: GridView.builder(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
            childAspectRatio: ResponsiveUtils.getGridChildAspectRatio(context),
            crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
            mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => onProductTap(product),
            );
          },
        ),
      ),
    );
  }
}

// Alternative: ListView for different layouts
class ResponsiveProductsList extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final ScrollController? scrollController;

  const ResponsiveProductsList({
    super.key,
    required this.products,
    required this.onProductTap,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        padding: ResponsiveUtils.getScreenPadding(context),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
            ),
            child: ProductCard(
              product: product,
              onTap: () => onProductTap(product),
            ),
          );
        },
      ),
    );
  }
}

// Staggered Grid for more dynamic layout
class ResponsiveStaggeredGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;

  const ResponsiveStaggeredGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.getGridCrossAxisCount(context);

    return Expanded(
      child: Padding(
        padding: ResponsiveUtils.getHorizontalPadding(context),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: ResponsiveUtils.getGridChildAspectRatio(
                  context,
                ),
                crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  16,
                ),
                mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  16,
                ),
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () => onProductTap(product),
                );
              }, childCount: products.length),
            ),
          ],
        ),
      ),
    );
  }
}
