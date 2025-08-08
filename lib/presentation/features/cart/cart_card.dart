import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/cart.dart';

class CartCard extends StatelessWidget {
  final Cart cart;
  const CartCard({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.productBackground,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cart #${cart.id}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('User: ${cart.userId}'),
            Text('Date: ${cart.date}'),
            Text('Items: ${cart.products.length}'),
          ],
        ),
      ),
    );
  }
}
