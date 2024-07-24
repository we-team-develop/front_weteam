enum WeteamAuthProvider { naver, kakao, google, apple }

abstract class AuthHelper {
  /// 로그인을 시도하는 메소드
  Future<bool> login();

  /// 로그아웃을 시도하는 메소드
  Future<bool> logout();

  /// 토큰을 받아오는 메소드
  Future<String?> getToken();

  /// 로그인 여부를 확인하는 메소드
  Future<bool> isLoggedIn();

  WeteamAuthProvider getProvider();
}
