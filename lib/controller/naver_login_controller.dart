import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:front_weteam/controller/auth_controller.dart';

class NaverLoginController extends AuthController {
  @override
  Future<String> getToken() async {
    if (!(await isLoggedIn())) {
      // TODO: 로그인 상태가 아닐 경우 핸들링
      throw UnimplementedError();
    }

    // TODO: firebase custom token?
    final NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
    return res.accessToken;
  }

  @override
  Future<bool> isLoggedIn() async {
    return await FlutterNaverLogin.isLoggedIn;
  }

  @override
  Future<bool> login() async {
    try {
      final NaverLoginResult res = await FlutterNaverLogin.logIn();
      bool success = await isLoggedIn(); // 성공 여부
      return success;
    } catch (error) {
      // TODO: 로그인 오류 핸들링
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await FlutterNaverLogin.logOut();
      return true;
    } catch (error) {
      // TODO: 로그아웃 오류 핸들링
      return false;
    }
  }
}
