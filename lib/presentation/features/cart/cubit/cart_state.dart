import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;
  final String sizeLabel;

  const CartItem({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.sizeLabel,
  });

  CartItem copyWith({
    int? quantity,
  }) =>
      CartItem(
        productId: productId,
        title: title,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity ?? this.quantity,
        sizeLabel: sizeLabel,
      );

  @override
  List<Object?> get props =>
      [productId, title, imageUrl, price, quantity, sizeLabel];
}

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double total;

  const CartLoaded({
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  CartLoaded copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? shipping,
    double? total,
  }) =>
      CartLoaded(
        items: items ?? this.items,
        subtotal: subtotal ?? this.subtotal,
        shipping: shipping ?? this.shipping,
        total: total ?? this.total,
      );

  @override
  List<Object?> get props => [items, subtotal, shipping, total];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
