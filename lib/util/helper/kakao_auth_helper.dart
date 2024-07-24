import 'package:firebase_auth/firebase_auth.dart';

import '../../social/kakao.dart';
import 'auth_helper.dart';

class KakaoAuthHelper extends AuthHelper {
  @override
  Future<String?> getToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    return await user.getIdToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }

  @override
  Future<bool> login() async {
    bool kakaoResult = await Kakao.login();
    return kakaoResult;
  }

  @override
  Future<bool> logout() async {
    await Kakao.logout();
    return true;
  }

  @override
  WeteamAuthProvider getProvider() {
    return WeteamAuthProvider.kakao;
  }
}
