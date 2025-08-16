import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/datasources/api_client.dart';
import '../../../../data/models/cart.dart';
import '../../../../data/models/product.dart';
import 'cart_state.dart';

@injectable
class CartCubit extends Cubit<CartState> {
  final ApiClient _apiClient;
  static const double _shippingFlat = 5.0;

  CartCubit(this._apiClient) : super(const CartInitial());

  Future<void> load() async {
    emit(const CartLoading());
    try {
      final List<Cart> carts = await _apiClient.getCarts();
      final Map<int, int> productIdToQuantity = {};
      for (final cart in carts) {
        for (final cp in cart.products) {
          productIdToQuantity.update(
            cp.productId,
            (value) => value + cp.quantity,
            ifAbsent: () => cp.quantity,
          );
        }
      }

      final ids = productIdToQuantity.keys.toList();
      final futures = ids.map((id) => _apiClient.getProduct(id)).toList();
      final List<Product> products = await Future.wait(futures);

      final sizes = ['S', 'M', 'L', 'XL'];
      double subtotal = 0;
      final items = <CartItem>[];
      for (int i = 0; i < products.length; i++) {
        final p = products[i];
        final qty = productIdToQuantity[p.id] ?? 0;
        subtotal += p.price * qty;
        items.add(CartItem(
          productId: p.id,
          title: p.title,
          imageUrl: p.image,
          price: p.price,
          quantity: qty,
          sizeLabel: sizes[i % sizes.length],
        ));
      }

      emit(CartLoaded(
        items: items,
        subtotal: subtotal,
        shipping: _shippingFlat,
        total: subtotal + _shippingFlat,
      ));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void increment(int productId) {
    final s = state;
    if (s is! CartLoaded) return;
    final items = s.items
        .map((it) => it.productId == productId
            ? it.copyWith(quantity: it.quantity + 1)
            : it)
        .toList();
    _recalculateAndEmit(items);
  }

  void decrement(int productId) {
    final s = state;
    if (s is! CartLoaded) return;
    final items = s.items.map((it) {
      if (it.productId == productId) {
        final newQty = it.quantity > 0 ? it.quantity - 1 : 0;
        return it.copyWith(quantity: newQty);
      }
      return it;
    }).toList();
    _recalculateAndEmit(items);
  }

  void remove(int productId) {
    final s = state;
    if (s is! CartLoaded) return;
    final items = s.items.where((it) => it.productId != productId).toList();
    _recalculateAndEmit(items);
  }

  void clear() {
    emit(const CartLoaded(
        items: [], subtotal: 0, shipping: _shippingFlat, total: _shippingFlat));
  }

  void _recalculateAndEmit(List<CartItem> items) {
    double subtotal = 0;
    for (final it in items) {
      subtotal += it.price * it.quantity;
    }
    emit(CartLoaded(
      items: items,
      subtotal: subtotal,
      shipping: _shippingFlat,
      total: subtotal + _shippingFlat,
    ));
  }
}
