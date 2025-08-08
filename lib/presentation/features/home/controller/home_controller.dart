import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/models/product.dart';
import '../../../../data/repositories/product_repository.dart';

@injectable
class HomeController extends ChangeNotifier {
  final ProductRepository _productRepository;

  HomeController(this._productRepository);

  List<Product> _products = [];
  List<String> _categories = [];
  String _selectedCategory = 'all';
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _setLoading(true);
    _error = null;

    try {
      print('Loading products for category: $_selectedCategory');

      if (_selectedCategory == 'all') {
        _products = await _productRepository.getAllProducts();
        print('Loaded ${_products.length} products for "all" category');
      } else {
        _products =
            await _productRepository.getProductsByCategory(_selectedCategory);
        print(
            'Loaded ${_products.length} products for category: $_selectedCategory');
      }

      if (_products.isEmpty) {
        print('No products found for category: $_selectedCategory');
      } else {
        print(
            'Products loaded successfully. First product: ${_products.first.title}');
      }
    } catch (e) {
      print('Error loading products for category $_selectedCategory: $e');
      _error = e.toString();
      _products = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadCategories() async {
    try {
      print('Loading categories...');
      final categories = await _productRepository.getCategories();
      _categories = ['all', ...categories];
      print('Loaded categories: $_categories');
      print('Total categories count: ${_categories.length}');
      notifyListeners();
    } catch (e) {
      print('Error loading categories: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    print('Selecting category: $category (current: $_selectedCategory)');
    if (_selectedCategory != category) {
      _selectedCategory = category;
      print('Category changed to: $_selectedCategory');
      notifyListeners();
      loadProducts();
    } else {
      print('Category already selected: $category');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void retry() {
    print('Retrying to load products...');
    loadProducts();
  }
}
