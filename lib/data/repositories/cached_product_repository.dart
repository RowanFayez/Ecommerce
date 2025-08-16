import 'package:injectable/injectable.dart';
import '../../core/network/network_info.dart';
import '../../core/hive/product_local_cache.dart';
import '../datasources/api_client.dart';
import '../models/product.dart';
import 'product_repository.dart';

class NoConnectionNoCache implements Exception {
  final String message;
  NoConnectionNoCache([this.message = 'No internet connection and no cached data found.']);
  @override
  String toString() => message;
}

@LazySingleton(as: ProductRepository)
class CachedProductRepository implements ProductRepository {
  final ApiClient _apiClient;
  final INetworkInfo _networkInfo;
  final ProductLocalCache _cache;

  CachedProductRepository(this._apiClient, this._networkInfo, this._cache);

  @override
  Future<List<Product>> getAllProducts() async {
    final connected = await _networkInfo.isConnected;
    if (connected) {
      try {
        final products = await _apiClient.getProducts();
        await _cache.saveProducts(products);
        return products;
      } catch (_) {
        final cached = _cache.getProducts();
        if (cached.isNotEmpty) return cached;
        rethrow;
      }
    } else {
      final cached = _cache.getProducts();
      if (cached.isNotEmpty) return cached;
      throw NoConnectionNoCache('Connect to Wi‑Fi please');
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final all = await getAllProducts();
    if (category.toLowerCase() == 'all') return all;
    return all
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList(growable: false);
  }

  @override
  Future<Product> getProductById(int id) async {
    final connected = await _networkInfo.isConnected;
    if (connected) {
      try {
        final product = await _apiClient.getProduct(id);
        final current = _cache.getProducts();
        final map = {for (final p in current) p.id: p};
        map[id] = product;
        await _cache.saveProducts(map.values.toList());
        return product;
      } catch (_) {
        final local = _cache.getProducts().firstWhere(
          (p) => p.id == id,
          orElse: () => throw NoConnectionNoCache('Product not available offline'),
        );
        return local;
      }
    } else {
      final local = _cache.getProducts().firstWhere(
        (p) => p.id == id,
        orElse: () => throw NoConnectionNoCache('Product not available offline'),
      );
      return local;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    final connected = await _networkInfo.isConnected;
    if (connected) {
      try {
        final categories = await _apiClient.getCategories();
        await _cache.saveCategories(categories);
        return categories;
      } catch (_) {
        final cached = _cache.getCategories();
        if (cached.isNotEmpty) return cached;
        rethrow;
      }
    } else {
      final cached = _cache.getCategories();
      if (cached.isNotEmpty) return cached;
      throw NoConnectionNoCache('Connect to Wi‑Fi please');
    }
  }
}
