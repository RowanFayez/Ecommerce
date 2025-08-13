import 'package:flutter/material.dart';
import '../managers/shared_prefrences_manager.dart';

class AuthTokenStore extends ChangeNotifier {
  String? _token;
  bool _isInitialized = false;

  String? get token => _token;
  bool get hasToken => _token != null && _token!.isNotEmpty;
  bool get isAuthenticated => hasToken;

  /// Initialize the token store by loading from SharedPreferences
  Future<void> initialize() async {
    if (_isInitialized) return;

    await SharedPreferenceManager.init();
    _token = SharedPreferenceManager.getToken();
    _isInitialized = true;
    notifyListeners();
  }

  /// Save token to both memory and SharedPreferences
  Future<void> save(String token) async {
    await SharedPreferenceManager.init();
    _token = token;
    await SharedPreferenceManager.setToken(token: token);
    notifyListeners();
  }

  /// Clear token from both memory and SharedPreferences
  Future<void> clear() async {
    await SharedPreferenceManager.init();
    _token = null;
    await SharedPreferenceManager.removeToken();
    notifyListeners();
  }
}
