import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/product.dart';
import '../models/cart.dart';
import '../models/user.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://fakestoreapi.com')
abstract class ApiClient {
  @GET('/users')
  Future<List<User>> getUsers();
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/products')
  Future<List<Product>> getProducts();

  @GET('/products/{id}')
  Future<Product> getProduct(@Path('id') int id);

  @GET('/products/categories')
  Future<List<String>> getCategories();

  @GET('/products/category/{category}')
  Future<List<Product>> getProductsByCategory(
      @Path('category') String category);

  @GET('/carts')
  Future<List<Cart>> getCarts();

  @GET('/carts/{id}')
  Future<Cart> getCart(@Path('id') int id);

  @GET('/carts/user/{userId}')
  Future<List<Cart>> getUserCarts(@Path('userId') int userId);
}
