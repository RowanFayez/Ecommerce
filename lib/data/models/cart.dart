import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
class Cart {
  final int id;
  final int userId;
  final String date;
  final List<CartProduct> products;

  const Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
}

@JsonSerializable()
class CartProduct {
  final int productId;
  final int quantity;

  const CartProduct({
    required this.productId,
    required this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => _$CartProductFromJson(json);
  Map<String, dynamic> toJson() => _$CartProductToJson(this);
}