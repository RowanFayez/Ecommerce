import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/models/product.dart';
import '../../../../data/repositories/product_repository.dart';

@injectable
class HomeController extends ChangeNotifier {
  final ProductRepository _productRepository;

  HomeController(this._productRepository);

  List<Product> _products = [];
  List<Product> _allProducts = []; // Store all products for local filtering
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
      print(
          'HomeController.loadProducts: Loading products for category: "$_selectedCategory"');
      print(
          'HomeController.loadProducts: Selected category type: ${_selectedCategory.runtimeType}');
      print(
          'HomeController.loadProducts: Selected category length: ${_selectedCategory.length}');

      // Always load all products first (only once)
      if (_allProducts.isEmpty) {
        print(
            'HomeController.loadProducts: Loading all products for the first time...');
        _allProducts = await _productRepository.getAllProducts();
        print(
            'HomeController.loadProducts: Loaded ${_allProducts.length} total products');
      }

      // Use local filtering instead of API calls
      if (_selectedCategory == 'all') {
        print(
            'HomeController.loadProducts: Using local filtering for "all" category');
        _products = List.from(_allProducts);
        print(
            'HomeController.loadProducts: Filtered ${_products.length} products for "all" category');
      } else {
        print(
            'HomeController.loadProducts: Using local filtering for category: "$_selectedCategory"');
        _products = _allProducts.where((product) {
          final productCategory = product.category.toLowerCase();
          final selectedCategory = _selectedCategory.toLowerCase();
          final matches = productCategory == selectedCategory;
          print(
              'HomeController.loadProducts: Product "${product.title}" - Category: "$productCategory" matches "$selectedCategory": $matches');
          return matches;
        }).toList();
        print(
            'HomeController.loadProducts: Filtered ${_products.length} products for category: "$_selectedCategory"');
      }

      if (_products.isEmpty) {
        print(
            'HomeController.loadProducts: No products found for category: "$_selectedCategory"');
      } else {
        print(
            'HomeController.loadProducts: Products loaded successfully. First product: ${_products.first.title}');
        print(
            'HomeController.loadProducts: First product category: ${_products.first.category}');
        print(
            'HomeController.loadProducts: First product image: ${_products.first.image}');
      }
    } catch (e) {
      print(
          'HomeController.loadProducts: Error loading products for category "$_selectedCategory": $e');
      print('HomeController.loadProducts: Error type: ${e.runtimeType}');
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
    print('HomeController.selectCategory: Called with category: "$category"');
    print(
        'HomeController.selectCategory: Current selected category: "$_selectedCategory"');
    print('HomeController.selectCategory: Categories available: $_categories');
    print(
        'HomeController.selectCategory: Category type: ${category.runtimeType}');
    print('HomeController.selectCategory: Category length: ${category.length}');

    if (_selectedCategory != category) {
      print(
          'HomeController.selectCategory: Category changed from "$_selectedCategory" to "$category"');
      _selectedCategory = category;
      print(
          'HomeController.selectCategory: Category changed to: $_selectedCategory');
      notifyListeners();

      // Use local filtering instead of API call
      if (_allProducts.isNotEmpty) {
        print(
            'HomeController.selectCategory: Using local filtering for immediate response');
        _filterProductsLocally();
      } else {
        print('HomeController.selectCategory: Loading products first time');
        loadProducts();
      }
    } else {
      print(
          'HomeController.selectCategory: Category already selected: $category');
    }
  }

  // Local filtering method for immediate response
  void _filterProductsLocally() {
    try {
      print(
          'HomeController._filterProductsLocally: Filtering products for category: "$_selectedCategory"');

      if (_selectedCategory == 'all') {
        _products = List.from(_allProducts);
        print(
            'HomeController._filterProductsLocally: Filtered ${_products.length} products for "all" category');
      } else {
        _products = _allProducts.where((product) {
          final productCategory = product.category.toLowerCase();
          final selectedCategory = _selectedCategory.toLowerCase();
          final matches = productCategory == selectedCategory;
          return matches;
        }).toList();
        print(
            'HomeController._filterProductsLocally: Filtered ${_products.length} products for category: "$_selectedCategory"');
      }

      notifyListeners();
    } catch (e) {
      print(
          'HomeController._filterProductsLocally: Error in local filtering: $e');
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
