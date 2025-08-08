import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../data/datasources/api_client.dart';
import '../../../data/models/cart.dart';
import 'cart_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cart>>(
      future: getIt<ApiClient>().getCarts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: \\${snapshot.error}'));
        }
        final carts = snapshot.data ?? [];
        if (carts.isEmpty) {
          return const Center(child: Text('No carts found'));
        }
        return ListView.builder(
          itemCount: carts.length,
          itemBuilder: (context, index) {
            final cart = carts[index];
            return CartCard(cart: cart);
          },
        );
      },
    );
  }
}
