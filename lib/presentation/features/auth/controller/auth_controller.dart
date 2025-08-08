class AuthController {
  Future<void> login(String email, String password) async {
    print("Logging in with: \$email / \$password");
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> signup(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    print("Signing up \$name with \$email and \$phone");
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
