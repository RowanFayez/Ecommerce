import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class ProductsInitialized extends ProductEvent {
  const ProductsInitialized();
}

class CategorySelected extends ProductEvent {
  final String category;
  const CategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}

class ProductsRefreshed extends ProductEvent {
  const ProductsRefreshed();
}

class ProductsRetryRequested extends ProductEvent {
  const ProductsRetryRequested();
}
