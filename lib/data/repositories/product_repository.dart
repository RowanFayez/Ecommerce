import 'package:injectable/injectable.dart';
import '../models/product.dart';
import '../datasources/api_client.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<List<Product>> getProductsByCategory(String category);
  Future<Product> getProductById(int id);
  Future<List<String>> getCategories();
}

@Injectable(as: ProductRepository)
class ApiProductRepository implements ProductRepository {
  final ApiClient _apiClient;

  ApiProductRepository(this._apiClient);

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      print('ProductRepository: Fetching all products...');
      final products = await _apiClient.getProducts();
      print(
          'ProductRepository: Successfully fetched ${products.length} products');

      if (products.isNotEmpty) {
        print(
            'ProductRepository: Sample product - ${products.first.title} (${products.first.category})');
      }

      return products;
    } catch (e) {
      print('ProductRepository: Error fetching all products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      print('ProductRepository: Fetching products for category: "$category"');
      final products = await _apiClient.getProductsByCategory(category);
      print(
          'ProductRepository: Successfully fetched ${products.length} products for category: "$category"');

      if (products.isNotEmpty) {
        print(
            'ProductRepository: Sample product from category "$category" - ${products.first.title}');
      } else {
        print('ProductRepository: No products found for category "$category"');
      }

      return products;
    } catch (e) {
      print(
          'ProductRepository: Error fetching products for category "$category": $e');
      throw Exception('Failed to fetch products by category: $e');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      print('ProductRepository: Fetching product with ID: $id');
      final product = await _apiClient.getProduct(id);
      print(
          'ProductRepository: Successfully fetched product: ${product.title}');
      return product;
    } catch (e) {
      print('ProductRepository: Error fetching product with ID $id: $e');
      throw Exception('Failed to fetch product: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      print('ProductRepository: Fetching categories...');
      final categories = await _apiClient.getCategories();
      print('ProductRepository: Successfully fetched categories: $categories');
      print('ProductRepository: Total categories count: ${categories.length}');
      return categories;
    } catch (e) {
      print('ProductRepository: Error fetching categories: $e');
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
