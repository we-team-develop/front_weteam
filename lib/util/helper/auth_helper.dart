abstract class AuthHelper {
  Future<bool> login();

  Future<bool> logout();

  Future<String?> getToken();

  Future<bool> isLoggedIn();
}
