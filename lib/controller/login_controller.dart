import 'package:get/get.dart';

import '../social/kakao.dart';

class LoginController extends GetxController {
  // Kakao 로그인
  void loginKakao(void Function(bool) callback) {
    Kakao.login().then((isSuccess) {
      callback(isSuccess);
    });
  }

}
