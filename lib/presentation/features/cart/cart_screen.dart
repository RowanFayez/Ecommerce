import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/services/auth_token_store.dart';
import '../../../core/network/network_info.dart';
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
                    child: FutureBuilder<bool>(
                      future: getIt<INetworkInfo>().isConnected,
                      builder: (context, snap) {
                        final online = snap.data ?? false;
                        final isAuthed = context.read<AuthTokenStore>().isAuthenticated;
                        final canCheckout = online && isAuthed;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppButton(
                              label: 'Checkout  →',
                              isFullWidth: true,
                              backgroundColor: AppColors.cartButtonBackground,
                              textColor: AppColors.cartButtonIcon,
                              onPressed: canCheckout
                                  ? () {
                                      final s = context.read<CartCubit>().state;
                                      if (s is! CartLoaded) return;
                                      _showCheckoutDialog(context, s);
                                    }
                                  : null,
                            ),
                            if (!canCheckout)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  !online
                                      ? 'You are offline. Connect to complete checkout.'
                                      : 'Please log in to checkout.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ),
                          ],
                        );
                      },
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

  void _showCheckoutDialog(BuildContext context, CartLoaded state) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Checkout',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim, __, ___) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return Transform.scale(
          scale: 0.9 + 0.1 * curved.value,
          child: Opacity(
            opacity: curved.value,
            child: Center(
              child: _CheckoutCard(state: state),
            ),
          ),
        );
      },
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

class _CheckoutCard extends StatefulWidget {
  final CartLoaded state;
  const _CheckoutCard({required this.state});

  @override
  State<_CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<_CheckoutCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _tick;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _tick = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ScaleTransition(
                  scale: _tick,
                  child: const CircleAvatar(
                    backgroundColor: AppColors.successGreen,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Ready to Checkout', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _summaryRow('Items', widget.state.items.length.toString()),
            _summaryRow('Subtotal', '\$${widget.state.subtotal.toStringAsFixed(2)}'),
            _summaryRow('Shipping', '\$${widget.state.shipping.toStringAsFixed(2)}'),
            const Divider(height: 20),
            _summaryRow('Total', '\$${(widget.state.total).toStringAsFixed(2)}', bold: true),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Pay Now',
                    onPressed: () {
                      // Simulate success
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment successful! Order placed.')),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
        ],
      ),
    );
  }
}
