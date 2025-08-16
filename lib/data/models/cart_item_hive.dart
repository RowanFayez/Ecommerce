import 'package:hive/hive.dart';

part 'cart_item_hive.g.dart';

@HiveType(typeId: 3)
class CartItemHive {
  @HiveField(0)
  final int productId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final int quantity;
  @HiveField(5)
  final String sizeLabel;

  const CartItemHive({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.sizeLabel,
  });

  CartItemHive copyWith({int? quantity}) => CartItemHive(
        productId: productId,
        title: title,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity ?? this.quantity,
        sizeLabel: sizeLabel,
      );
}
