import 'package:injectable/injectable.dart';
import '../models/cart.dart';
import '../datasources/api_client.dart';

abstract class CartRepository {
  Future<List<Cart>> getAllCarts();
  Future<Cart> getCartById(int id);
  Future<List<Cart>> getUserCarts(int userId);
}

@Injectable(as: CartRepository)
class ApiCartRepository implements CartRepository {
  final ApiClient _apiClient;

  ApiCartRepository(this._apiClient);

  @override
  Future<List<Cart>> getAllCarts() async {
    try {
      return await _apiClient.getCarts();
    } catch (e) {
      throw Exception('Failed to fetch carts: $e');
    }
  }

  @override
  Future<Cart> getCartById(int id) async {
    try {
      return await _apiClient.getCart(id);
    } catch (e) {
      throw Exception('Failed to fetch cart: $e');
    }
  }

  @override
  Future<List<Cart>> getUserCarts(int userId) async {
    try {
      return await _apiClient.getUserCarts(userId);
    } catch (e) {
      throw Exception('Failed to fetch user carts: $e');
    }
  }
}