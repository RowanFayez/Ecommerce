import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/hive/cart_local_cache.dart';
import '../../../../data/datasources/api_client.dart';
import '../../../../data/models/cart.dart';
import '../../../../data/models/cart_item_hive.dart';
import 'cart_state.dart';

@injectable
class CartCubit extends Cubit<CartState> {
  final ApiClient _apiClient;
  final CartLocalCache _local;
  static const double _shippingFlat = 5.0;

  CartCubit(this._apiClient, this._local) : super(const CartInitial());

  Future<void> load() async {
    // If we already have data, avoid flicker and unnecessary remote fetch immediately
    if (state is CartLoaded) {
      // Still try a silent merge refresh in background
      _silentRefresh();
      return;
    }
    emit(const CartLoading());
    try {
      // 1) Show local cache immediately if present
      final cached = _local.getItems();
      final bool hadCached = cached.isNotEmpty;
      if (hadCached) {
        final localItems = cached
            .map((e) => CartItem(
                  productId: e.productId,
                  title: e.title,
                  imageUrl: e.imageUrl,
                  price: e.price,
                  quantity: e.quantity,
                  sizeLabel: e.sizeLabel,
                ))
            .toList();
        _recalculateAndEmit(localItems);
      }

      // 2) Try to refresh from remote when possible and MERGE with local (preserve local quantities)
      final List<Cart> carts = await _apiClient.getCarts();
      final Map<int, int> remoteQty = {};
      for (final cart in carts) {
        for (final cp in cart.products) {
          remoteQty.update(
            cp.productId,
            (value) => value + cp.quantity,
            ifAbsent: () => cp.quantity,
          );
        }
      }

      final ids = remoteQty.keys.toList();
      final products = await Future.wait(ids.map((id) => _apiClient.getProduct(id)));

      final sizes = ['S', 'M', 'L', 'XL'];
      // Start from local map
      final Map<int, CartItem> merged = {
        for (final it in (state is CartLoaded ? (state as CartLoaded).items : <CartItem>[]))
          it.productId: it
      };

      for (int i = 0; i < products.length; i++) {
        final p = products[i];
        final qtyRemote = remoteQty[p.id] ?? 0;
        final existing = merged[p.id];
        // Preserve local quantity if exists, otherwise use remote
        final qty = existing?.quantity ?? qtyRemote;
        merged[p.id] = CartItem(
          productId: p.id,
          title: p.title,
          imageUrl: p.image,
          price: p.price,
          quantity: qty,
          sizeLabel: existing?.sizeLabel ?? sizes[i % sizes.length],
        );
      }

      final items = merged.values.where((e) => e.quantity > 0).toList();
      await _persist(items);
      _recalculateAndEmit(items);
    } catch (e) {
      // If we already showed cached, keep it; otherwise show friendly offline message
      if (state is CartLoaded) return;
      emit(const CartError('No internet connection. Connect to load your cart.'));
    }
  }

  Future<void> _silentRefresh() async {
    try {
      // Reuse the same logic but without resetting state when offline/errors
      final cachedItems = (state is CartLoaded) ? (state as CartLoaded).items : <CartItem>[];

      final List<Cart> carts = await _apiClient.getCarts();
      final Map<int, int> remoteQty = {};
      for (final cart in carts) {
        for (final cp in cart.products) {
          remoteQty.update(
            cp.productId,
            (value) => value + cp.quantity,
            ifAbsent: () => cp.quantity,
          );
        }
      }
      final ids = remoteQty.keys.toList();
      final products = await Future.wait(ids.map((id) => _apiClient.getProduct(id)));
      final sizes = ['S', 'M', 'L', 'XL'];

      final Map<int, CartItem> merged = {for (final it in cachedItems) it.productId: it};
      for (int i = 0; i < products.length; i++) {
        final p = products[i];
        final qtyRemote = remoteQty[p.id] ?? 0;
        final existing = merged[p.id];
        final qty = existing?.quantity ?? qtyRemote;
        merged[p.id] = CartItem(
          productId: p.id,
          title: p.title,
          imageUrl: p.image,
          price: p.price,
          quantity: qty,
          sizeLabel: existing?.sizeLabel ?? sizes[i % sizes.length],
        );
      }
      final items = merged.values.where((e) => e.quantity > 0).toList();
      await _persist(items);
      _recalculateAndEmit(items);
    } catch (_) {
      // ignore
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
    _persist(items);
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
    _persist(items);
  }

  void remove(int productId) {
    final s = state;
    if (s is! CartLoaded) return;
    final items = s.items.where((it) => it.productId != productId).toList();
    _recalculateAndEmit(items);
    _persist(items);
  }

  void clear() {
    emit(CartLoaded(items: const [], subtotal: 0, shipping: _shippingFlat, total: _shippingFlat));
    _local.clear();
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

  Future<void> _persist(List<CartItem> items) async {
    await _local.saveItems(items
        .map((e) => CartItemHive(
              productId: e.productId,
              title: e.title,
              imageUrl: e.imageUrl,
              price: e.price,
              quantity: e.quantity,
              sizeLabel: e.sizeLabel,
            ))
        .toList());
  }
}
