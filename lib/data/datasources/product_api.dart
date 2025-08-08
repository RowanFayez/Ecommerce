import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/product.dart';

part 'product_api.g.dart';

@RestApi(baseUrl: 'https://fakestoreapi.com/')
abstract class ProductApi {
  factory ProductApi(Dio dio, {String baseUrl}) = _ProductApi;

  @GET('/products')
  Future<List<Product>> getProducts();
}
