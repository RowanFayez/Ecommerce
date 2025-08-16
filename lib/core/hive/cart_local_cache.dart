import 'package:hive/hive.dart';
import '../../data/models/cart_item_hive.dart';
import 'hive_setup.dart';

class CartLocalCache {
  Box<CartItemHive> get _cartBox => Hive.box<CartItemHive>(cartBoxKey);

  List<CartItemHive> getItems() => _cartBox.values.toList(growable: false);

  Future<void> saveItems(List<CartItemHive> items) async {
    await _cartBox.clear();
    for (final it in items) {
      await _cartBox.put(it.productId, it);
    }
  }

  Future<void> upsertItem(CartItemHive item) async {
    await _cartBox.put(item.productId, item);
  }

  Future<void> removeItem(int productId) async {
    await _cartBox.delete(productId);
  }

  Future<void> clear() async {
    await _cartBox.clear();
  }
}
