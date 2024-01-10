import 'package:front_weteam/model/weteam_user.dart';
import 'package:front_weteam/util/helper/auth_helper.dart';
import 'package:front_weteam/util/provider/weteam_auth_provider.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends GetxService {
  AuthHelper? helper;
  String? token;

  Future<bool> login(AuthHelper authHelper) async {
    try {
      if (helper != null) {
        if (await helper!.isLoggedIn()) {
          await logout(); // 기존 로그인
        }
      }

      helper = authHelper;
      bool result = await helper!.login();
      if (!result) {
        debugPrint("helper 로그인 실패");
        return false;
      }

      token = await helper!.getToken();
      WeteamUser? user = await Get.find<WeteamAuthProvider>().getCurrentUser();
      if (user != null) {
        debugPrint('반갑습니다 ${user.username}님');
        return true;
      } else {
        debugPrint("user값을 받아오지 못함!");
        return false;
      }
    } catch(e) {
      debugPrint("로그인 실패: $e");
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      if (helper == null) return true; // false?
      if (!await helper!.logout()) return false; // 플랫폼별 로그아웃
      await FirebaseAuth.instance.signOut(); // firebase 로그아웃

      return true;
    } catch (e) {
      debugPrint("로그아웃 중 예외발생: $e");
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      if (helper == null) return false;
      return await helper!.isLoggedIn();
    } catch (e) {
      debugPrint("로그인 상태 확인 중 예외발생: $e");
      return false;
    }
  }
}
