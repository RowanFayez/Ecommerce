import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../data/datasources/api_client.dart';
import '../../../../data/models/auth_request.dart';
import '../../../../data/models/user.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/auth_token_store.dart';
import '../../../../core/services/local_user_store.dart';

class AuthController {
  final ApiClient _apiClient;
  final AuthTokenStore _authTokenStore;
  static bool _googleInitialized = false;

  AuthController({
    ApiClient? apiClient,
    AuthTokenStore? authTokenStore,
  })  : _apiClient = apiClient ?? getIt<ApiClient>(),
        _authTokenStore = authTokenStore ?? getIt<AuthTokenStore>();

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

      // Persist token and update auth state
      await _authTokenStore.save(response.token);

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

      // If FakeStore rejects credentials (common for non-demo users),
      // try matching against /users and locally created users.
      if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
        final fallback = await _tryDatasetLogin(email, password);
        if (fallback['success'] == true) {
          return fallback;
        }
        errorMessage = 'Invalid username/email or password';
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

  /// Google Sign-In for Android/Web using Firebase Auth
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      fb.UserCredential userCredential;

      if (kIsWeb) {
        // Web: use popup to avoid full page redirect
        final provider = fb.GoogleAuthProvider();
        provider.setCustomParameters({'prompt': 'select_account'});
        userCredential = await fb.FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        // Android/iOS: use GoogleSignIn v7 API (no direct constructor)
        final signIn = GoogleSignIn.instance;
        if (!_googleInitialized) {
          await signIn.initialize();
          _googleInitialized = true;
        }

        // Starts an interactive sign-in process
  final account = await signIn.authenticate();
  final tokens = account.authentication;
        final credential = fb.GoogleAuthProvider.credential(
          // google_sign_in v7 exposes only idToken; that's sufficient
          idToken: tokens.idToken,
        );
        userCredential =
            await fb.FirebaseAuth.instance.signInWithCredential(credential);
      }

      final fb.User? user = userCredential.user;
      if (user == null) {
        return {'success': false, 'message': 'No user information available'};
      }

      final idToken = await user.getIdToken();
      if (idToken == null || idToken.isEmpty) {
        return {
          'success': false,
          'message': 'Failed to obtain ID token',
        };
      }
      await _authTokenStore.save(idToken);

      return {
        'success': true,
        'message': 'Google sign-in successful',
        'user': {
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
          'photo': user.photoURL,
        }
      };
  } on fb.FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': e.message ?? 'Google sign-in failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Google sign-in error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> _tryDatasetLogin(
      String usernameOrEmail, String password) async {
    try {
      print('🔎 Fallback: validating against dataset and local users...');
      final apiUsers = await _apiClient.getUsers();
      final localUsers = getIt.isRegistered<LocalUserStore>()
          ? getIt<LocalUserStore>().users
          : const <User>[];
      final all = [...apiUsers, ...localUsers];
      final input = usernameOrEmail.trim();
      final match = all.firstWhere(
        (u) =>
            (u.username == input || u.email == input) && u.password == password,
        orElse: () => const User(
          id: -1,
          email: '',
          username: '',
          password: '',
          name: Name(firstname: '', lastname: ''),
          phone: '',
          address: Address(
            city: '',
            street: '',
            number: 0,
            zipcode: '',
            geolocation: GeoLocation(lat: '', long: ''),
          ),
        ),
      );
      if (match.id != -1) {
        final token =
            'local-demo-token-${match.username}-${DateTime.now().millisecondsSinceEpoch}';
        await _authTokenStore.save(token);
        return {
          'success': true,
          'token': token,
          'message': 'Login successful',
        };
      }
    } catch (err) {
      print('❌ Dataset/local login failed: $err');
    }
    return {'success': false, 'message': 'Invalid credentials'};
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

  /// Logout user and clear all authentication data
  Future<void> logout() async {
  // Firebase sign-out (for Google accounts)
    try {
      final auth = fb.FirebaseAuth.instance;
      if (auth.currentUser != null) {
        await auth.signOut();
      }
    } catch (_) {}

    await _authTokenStore.clear();
  }

  /// Get current authentication state
  bool get isAuthenticated => _authTokenStore.isAuthenticated;
  String? get token => _authTokenStore.token;
}
