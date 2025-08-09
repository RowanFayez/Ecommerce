import 'package:dio/dio.dart';
import '../../../../data/datasources/api_client.dart';
import '../../../../data/models/auth_request.dart';
import '../../../../data/models/user.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/auth_token_store.dart';

class AuthController {
  final ApiClient _apiClient;

  AuthController({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(Dio());

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🔐 Attempting login with: $email');

      final request = AuthRequest(
        username: email,
        password: password,
      );

      print('📤 Sending login request...');
      final response = await _apiClient.login(request);
      print('✅ Login successful! Token: ${response.token}');

      // Persist token for authenticated requests
      getIt<AuthTokenStore>().save(response.token);

      return {
        'success': true,
        'token': response.token,
        'message': 'Login successful',
      };
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');

      String errorMessage = 'Login failed';

      if (e.response?.statusCode == 401) {
        errorMessage = 'Invalid email or password';
      } else if (e.response?.statusCode == 400) {
        errorMessage = 'Please check your input';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      }

      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      print('❌ Unexpected error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> signup(
    String firstName,
    String lastName,
    String email,
    String password,
    String phone,
  ) async {
    try {
      print('📝 Attempting signup for: $email');

      final user = User(
        id: 0, // Will be assigned by the server
        email: email,
        username: email,
        password: password,
        name: Name(
          firstname: firstName,
          lastname: lastName,
        ),
        phone: phone,
        address: Address(
          city: 'Test City',
          street: 'Test Street',
          number: 123,
          zipcode: '12345',
          geolocation: GeoLocation(lat: '40.7128', long: '-74.0060'),
        ),
      );

      print('📤 Sending signup request...');
      final response = await _apiClient.signup(user);
      print('✅ Signup successful! User ID: ${response.id}');
      print('✅ User: ${response.name.firstname} ${response.name.lastname}');

      return {
        'success': true,
        'user': response,
        'message': 'Account created successfully',
      };
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');

      String errorMessage = 'Signup failed';

      if (e.response?.statusCode == 400) {
        errorMessage = 'Please check your input data';
      } else if (e.response?.statusCode == 409) {
        errorMessage = 'Email already exists. Please use a different email.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      }

      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      print('❌ Unexpected error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }
}
