import 'package:equatable/equatable.dart';
import '../../../../data/models/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoadInProgress extends ProductState {
  const ProductLoadInProgress();
}

class ProductLoadSuccess extends ProductState {
  final List<Product> products;
  final List<String> categories; // includes 'all'
  final String selectedCategory; // e.g., 'all' or a category

  const ProductLoadSuccess({
    required this.products,
    required this.categories,
    required this.selectedCategory,
  });

  ProductLoadSuccess copyWith({
    List<Product>? products,
    List<String>? categories,
    String? selectedCategory,
  }) => ProductLoadSuccess(
        products: products ?? this.products,
        categories: categories ?? this.categories,
        selectedCategory: selectedCategory ?? this.selectedCategory,
      );

  @override
  List<Object?> get props => [products, categories, selectedCategory];
}

class ProductLoadFailure extends ProductState {
  final String message;
  const ProductLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
