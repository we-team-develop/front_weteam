abstract class AuthController {
  Future<bool> login();

  Future<bool> logout();

  Future<String> getToken();

  Future<bool> isLoggedIn();
}
