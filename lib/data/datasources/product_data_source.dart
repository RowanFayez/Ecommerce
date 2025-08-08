import 'package:dio/dio.dart';
import '../models/product.dart';
import 'product_api.dart';

class ProductDataSource {
  final ProductApi api;

  ProductDataSource(Dio dio) : api = ProductApi(dio);

  Future<List<Product>> getAllProducts() async {
    return await api.getProducts();
  }
}
