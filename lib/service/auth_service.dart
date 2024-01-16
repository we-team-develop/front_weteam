import 'package:front_weteam/model/weteam_user.dart';
import 'package:front_weteam/service/api_service.dart';
import 'package:front_weteam/util/helper/auth_helper.dart';
import 'package:front_weteam/util/provider/weteam_auth_provider.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends GetxService {
  AuthHelper? helper;
  String? token;

  Future<LoginResult> login(AuthHelper authHelper, {bool checkNewUser = false}) async {
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
        return const LoginResult(isSuccess: false);
      }

      token = await helper!.getToken();
      WeteamUser? user = await Get.find<WeteamAuthProvider>().getCurrentUser();
      if (user != null) {
        debugPrint('반갑습니다 ${user.username}님');

        if (checkNewUser) {
          int? profileId = await Get.find<ApiService>().getMyProfiles();
          if (profileId == null) {
            debugPrint("로그인에 성공했으나 서버에서 프로필 id를 불러오지 못함");
            return const LoginResult(isSuccess: false);
          }

          bool isNewUser = profileId == -1;
          return LoginResult(isSuccess: true, user: user, isNewUser: isNewUser);
        }

        return LoginResult(isSuccess: true, user: user);
      } else {
        debugPrint("user값을 받아오지 못함!");
        return const LoginResult(isSuccess: false);
      }
    } catch(e) {
      debugPrint("로그인 실패: $e");
      return const LoginResult(isSuccess: false);
    }
  }

  Future<bool> logout() async {
    try {
      if (helper == null) return true; // false?
      if (!await helper!.logout()) return false; // 플랫폼별 로그아웃
      await FirebaseAuth.instance.signOut(); // firebase 로그아웃
      token = null;

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

class LoginResult {
  final WeteamUser? user;
  final bool isSuccess;
  final bool isNewUser;

  const LoginResult({required this.isSuccess, this.isNewUser = false, this.user});
}