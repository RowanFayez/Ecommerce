import 'package:hive/hive.dart';
import '../../data/models/product.dart';
import 'hive_setup.dart';

class ProductLocalCache {
  Box<Product> get _productsBox => Hive.box<Product>(productsBoxKey);
  Box get _metaBox => Hive.box(metaBoxKey);
  Box<List> get _categoriesBox => Hive.box<List>(categoriesBoxKey);

  Future<void> saveProducts(List<Product> products) async {
    await _productsBox.clear();
    for (final p in products) {
      await _productsBox.put(p.id, p);
    }
    await _metaBox.put('products_updated_at', DateTime.now().toIso8601String());
  }

  List<Product> getProducts() {
    return _productsBox.values.toList(growable: false);
  }

  DateTime? get productsUpdatedAt {
    final iso = _metaBox.get('products_updated_at') as String?;
    return iso != null ? DateTime.tryParse(iso) : null;
  }

  Future<void> saveCategories(List<String> categories) async {
    await _categoriesBox.put('items', categories);
    await _metaBox.put('categories_updated_at', DateTime.now().toIso8601String());
  }

  List<String> getCategories() {
    final list = _categoriesBox.get('items');
    if (list == null) return const [];
    return List<String>.from(list);
  }

  DateTime? get categoriesUpdatedAt {
    final iso = _metaBox.get('categories_updated_at') as String?;
    return iso != null ? DateTime.tryParse(iso) : null;
  }
}
