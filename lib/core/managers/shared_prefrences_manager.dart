import 'package:shared_preferences/shared_preferences.dart';

const String _tokenKey = "token";
const String _isGuestKey = "isGuestUser";

class SharedPreferenceManager {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //TOKEN
  static Future<void> setToken({required String token}) async {
    await _prefs.setString(_tokenKey, token);
  }

  static String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  static Future<bool> removeToken() async {
    return await _prefs.remove(_tokenKey);
  }
//guest
  static Future<void> setGuestUser(bool isGuest) async {
    await _prefs.setBool(_isGuestKey, isGuest);
  }

  static bool isGuestUser() {
    return _prefs.getBool(_isGuestKey) ?? false;
  }

  static Future<bool> removeGuestUser() async {
    return await _prefs.remove(_isGuestKey);
  }
}


