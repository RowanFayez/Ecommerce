import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/app_button.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/cart_state.dart';
import 'cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (_) => getIt<CartCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
          centerTitle: true,
          elevation: 0,
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.background,
        ),
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.background,
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading || state is CartInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CartError) {
              return _ErrorView(
                error: state.message,
                onRetry: () => context.read<CartCubit>().load(),
              );
            }
            if (state is CartLoaded) {
              if (state.items.isEmpty) {
                return const Center(child: Text('Your cart is empty'));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return CartItemTile(
                          imageUrl: item.imageUrl,
                          title: item.title,
                          sizeLabel: item.sizeLabel,
                          price: item.price,
                          quantity: item.quantity,
                          onIncrease: () => context
                              .read<CartCubit>()
                              .increment(item.productId),
                          onDecrease: () => context
                              .read<CartCubit>()
                              .decrement(item.productId),
                          onDelete: () =>
                              context.read<CartCubit>().remove(item.productId),
                        );
                      },
                    ),
                  ),
                  _TotalsCard(
                      subtotal: state.subtotal, shipping: state.shipping),
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
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// Totals card reused with Cubit values

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
