import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/datasources/api_client.dart';
import '../../../data/models/cart.dart';
import '../../../data/models/product.dart';
import 'cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBackground
            : AppColors.background,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBackground
          : AppColors.background,
      body: FutureBuilder<_CartPageData>(
        future: _loadCartPageData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorView(
                error: snapshot.error.toString(),
                onRetry: () => _retry(context));
          }
          final data = snapshot.data;
          if (data == null || data.items.isEmpty) {
            return const Center(child: Text('No carts found'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: data.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final item = data.items[index];
                    return CartItemTile(
                      imageUrl: item.imageUrl,
                      title: item.title,
                      sizeLabel: item.sizeLabel,
                      price: item.price,
                      quantity: item.quantity,
                      onIncrease: null,
                      onDecrease: null,
                      onDelete: null,
                    );
                  },
                ),
              ),
              _TotalsCard(subtotal: data.subtotal, shipping: 5.0),
              const SizedBox(height: 12),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AppButton(
                  label: 'Checkout  →',
                  isFullWidth: true,
                  backgroundColor: AppColors.cartButtonBackground,
                  textColor: AppColors.cartButtonIcon,
                  onPressed: () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _retry(BuildContext context) async {
    // Trigger a rebuild
    (context as Element).markNeedsBuild();
  }
}

class _CartItemData {
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;
  final String sizeLabel;
  const _CartItemData({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.sizeLabel,
  });
}

class _CartPageData {
  final List<_CartItemData> items;
  final double subtotal;
  const _CartPageData(this.items, this.subtotal);
}

Future<_CartPageData> _loadCartPageData() async {
  final api = getIt<ApiClient>();
  final List<Cart> carts = await api.getCarts();

  // Aggregate all products across all carts
  final Map<int, int> productIdToQuantity = {};
  for (final cart in carts) {
    for (final cp in cart.products) {
      productIdToQuantity.update(cp.productId, (value) => value + cp.quantity,
          ifAbsent: () => cp.quantity);
    }
  }

  // Fetch unique products in parallel
  final List<int> productIds = productIdToQuantity.keys.toList();
  final futures = productIds.map((id) => api.getProduct(id)).toList();
  final List<Product> products = await Future.wait(futures);

  // Map products to UI items
  final sizes = ['S', 'M', 'L', 'XL'];
  final List<_CartItemData> items = [];
  double subtotal = 0;
  for (int i = 0; i < products.length; i++) {
    final p = products[i];
    final qty = productIdToQuantity[p.id] ?? 0;
    subtotal += p.price * qty;
    items.add(_CartItemData(
      title: p.title,
      imageUrl: p.image,
      price: p.price,
      quantity: qty,
      sizeLabel: sizes[i % sizes.length],
    ));
  }

  return _CartPageData(items, subtotal);
}

class _TotalsCard extends StatelessWidget {
  final double subtotal;
  final double shipping;
  const _TotalsCard({required this.subtotal, required this.shipping});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = subtotal + shipping;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          _row('Sub total', subtotal),
          const Divider(height: 20),
          _row('Shipping', shipping),
          const Divider(height: 20),
          _row('Total', total, isBold: true),
        ],
      ),
    );
  }

  Widget _row(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            )),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: AppColors.warningRed),
            const SizedBox(height: 12),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            AppButton(label: 'Retry', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
