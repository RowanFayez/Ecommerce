import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/product.dart';
import '../../data/models/cart_item_hive.dart';

// Box names
const String productsBoxKey = 'products_box';
const String categoriesBoxKey = 'categories_box';
const String metaBoxKey = 'meta_box'; // simple key-value for timestamps, etc.
const String cartBoxKey = 'cart_box';

class HiveSetup {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters (safe to call multiple times)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(RatingAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(CartItemHiveAdapter());
    }

    // Open boxes used across the app
    await Future.wait([
      Hive.openBox<Product>(productsBoxKey),
      Hive.openBox<List>(categoriesBoxKey), // stores List<String>
      Hive.openBox(metaBoxKey),
      Hive.openBox<CartItemHive>(cartBoxKey),
    ]);
  }
}
