import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/product.dart';

// Box names
const String productsBoxKey = 'products_box';
const String categoriesBoxKey = 'categories_box';
const String metaBoxKey = 'meta_box'; // simple key-value for timestamps, etc.

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

    // Open boxes used across the app
    await Future.wait([
  Hive.openBox<Product>(productsBoxKey),
      Hive.openBox<List>(categoriesBoxKey), // stores List<String>
      Hive.openBox(metaBoxKey),
    ]);
  }
}
