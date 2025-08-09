import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/product.dart';
import '../models/cart.dart';
import '../models/user.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';

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

  // Authentication endpoints
  @POST('/auth/login')
  Future<AuthResponse> login(@Body() AuthRequest request);

  @POST('/users')
  Future<User> signup(@Body() User user);

  // User management endpoints
  @GET('/users/{id}')
  Future<User> getUser(@Path('id') int id);

  @PUT('/users/{id}')
  Future<User> updateUser(@Path('id') int id, @Body() User user);

  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path('id') int id);

  // Cart management endpoints
  @POST('/carts')
  Future<Cart> createCart(@Body() Cart cart);

  @PUT('/carts/{id}')
  Future<Cart> updateCart(@Path('id') int id, @Body() Cart cart);

  @DELETE('/carts/{id}')
  Future<void> deleteCart(@Path('id') int id);
}
