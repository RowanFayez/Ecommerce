// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemHiveAdapter extends TypeAdapter<CartItemHive> {
  @override
  final int typeId = 3;

  @override
  CartItemHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemHive(
      productId: fields[0] as int,
      title: fields[1] as String,
      imageUrl: fields[2] as String,
      price: fields[3] as double,
      quantity: fields[4] as int,
      sizeLabel: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.sizeLabel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
