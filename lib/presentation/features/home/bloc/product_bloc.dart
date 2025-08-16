import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/models/product.dart';
import '../../../../data/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;
  List<Product> _allProducts = const [];

  ProductBloc(this._repository) : super(const ProductInitial()) {
    on<ProductsInitialized>(_onInit);
    on<CategorySelected>(_onCategorySelected);
    on<ProductsRefreshed>(_onRefresh);
    on<ProductsRetryRequested>(_onRetry);
  }

  Future<void> _onInit(
    ProductsInitialized event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoadInProgress());
    try {
      final categories = await _repository.getCategories();
      final products = await _repository.getAllProducts();
      _allProducts = products;
      final catsWithAll = ['all', ...categories];
      emit(ProductLoadSuccess(
        products: List<Product>.from(_allProducts),
        categories: catsWithAll,
        selectedCategory: 'all',
      ));
    } catch (e) {
      emit(ProductLoadFailure(e.toString()));
    }
  }

  void _onCategorySelected(
    CategorySelected event,
    Emitter<ProductState> emit,
  ) {
    final current = state;
    if (current is ProductLoadSuccess) {
      final selected = event.category;
      final filtered = selected.toLowerCase() == 'all'
          ? List<Product>.from(_allProducts)
          : _allProducts
              .where((p) => p.category.toLowerCase() == selected.toLowerCase())
              .toList(growable: false);
      emit(current.copyWith(products: filtered, selectedCategory: selected));
    }
  }

  Future<void> _onRefresh(
    ProductsRefreshed event,
    Emitter<ProductState> emit,
  ) async {
    final selected = state is ProductLoadSuccess
        ? (state as ProductLoadSuccess).selectedCategory
        : 'all';
    emit(const ProductLoadInProgress());
    try {
      final categories = await _repository.getCategories();
      final products = await _repository.getAllProducts();
      _allProducts = products;
      final catsWithAll = ['all', ...categories];
      final filtered = selected.toLowerCase() == 'all'
          ? List<Product>.from(_allProducts)
          : _allProducts
              .where((p) => p.category.toLowerCase() == selected.toLowerCase())
              .toList(growable: false);
      emit(ProductLoadSuccess(
        products: filtered,
        categories: catsWithAll,
        selectedCategory: selected,
      ));
    } catch (e) {
      emit(ProductLoadFailure(e.toString()));
    }
  }

  Future<void> _onRetry(
    ProductsRetryRequested event,
    Emitter<ProductState> emit,
  ) async {
    return _onInit(const ProductsInitialized(), emit);
  }
}
