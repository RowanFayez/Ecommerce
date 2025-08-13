import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  // Convert to old Product model format for UI compatibility
  String get name => title;
  String get imageUrl => image;
  bool get isAvailable => true;
  double get ratingValue => rating.rate;
  int get reviewCount => rating.count;

  factory Product.fromJson(Map<String, dynamic> json) {
    print('Product.fromJson: Raw JSON data: $json');
    print('Product.fromJson: Image field value: ${json['image']}');
    print('Product.fromJson: Image field type: ${json['image'].runtimeType}');

    final product = _$ProductFromJson(json);
    print('Product.fromJson: Parsed product image: ${product.image}');
    return product;
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    Rating? rating,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price)';
  }
}

@JsonSerializable()
class Rating {
  final double rate;
  final int count;

  const Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
