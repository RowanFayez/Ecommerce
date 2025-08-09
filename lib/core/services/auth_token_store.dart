class AuthTokenStore {
  String? _token;

  String? get token => _token;

  bool get hasToken => _token != null && _token!.isNotEmpty;

  void save(String token) {
    _token = token;
  }

  void clear() {
    _token = null;
  }
}
