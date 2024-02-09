import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/weteam_user.dart';
import '../util/helper/auth_helper.dart';
import '../util/helper/google_auth_helper.dart';
import '../util/helper/kakao_auth_helper.dart';
import '../util/helper/naver_auth_helper.dart';
import '../util/mem_cache.dart';
import 'api_service.dart';

class AuthService extends GetxService {
  AuthHelper? helper;
  String? token;
  Rxn<WeteamUser> user = Rxn<WeteamUser>();


  @override
  void onInit() {
    dynamic firebaseIdToken = MemCache.get(MemCacheKey.firebaseAuthIdToken);
    dynamic userJson = MemCache.get(MemCacheKey.weteamUserJson);
    if (firebaseIdToken != null && userJson != null) {
      token = firebaseIdToken;
      debugPrint(token);
      user.value = WeteamUser.fromJson(jsonDecode(userJson));
      if (user.value!.profile == null) {
        user.value = null; // 로그인 취소
        return;
      }

      String uid = FirebaseAuth.instance.currentUser!.uid;
      if (uid.startsWith('naver')) {
        helper = NaverAuthHelper();
        debugPrint("네이버");
      } else if (uid.startsWith('kakao')) {
        helper = KakaoAuthHelper();
        debugPrint("카카오");
      } else {
        helper = GoogleAuthHelper();
        debugPrint("구글");
      }
    }

    Get.put(ApiService());
    Get.find<ApiService>().getCurrentUser().then((value) {
      if (value != null) user.value = value;
    });

    super.onInit();
  }

  Future<LoginResult> login(AuthHelper authHelper) async {
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
      debugPrint(token);
      WeteamUser? user = await Get.find<ApiService>().getCurrentUser();
      this.user.value = user;

      if (user != null) {
        debugPrint('반갑습니다 ${user.username}님');

        bool isNewUser = (user.profile == null);
        return LoginResult(isSuccess: true, user: user, isNewUser: isNewUser);
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
      user.value = null;

      /*sharedPreferences.remove(SharedPreferencesKeys.weteamUserJson);
      sharedPreferences.remove(SharedPreferencesKeys.isRegistered);*/
      debugPrint("SharedPreferences의 데이터를 모두 삭제하는 중");
      await sharedPreferences.clear();

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

  Future<bool> withdrawal() async {
    try {
      if (helper == null) return false;
      bool result = await Get.find<ApiService>().withdrawal();

      if (!result) {
        debugPrint("회원 탈퇴 api가 false를 반환함");
        return false;
      }

      await logout();
      return true;
    } catch (e) {
      debugPrint("회원탈퇴 중 예외발생: $e");
      return false;
    }
  }

  Future<WeteamUser?> updateUser() async {
    try {
      WeteamUser? user = await Get.find<ApiService>().getCurrentUser();
      if (user != null) {
        this.user.value = user;
        return this.user.value;
      }
    } catch (e, st) {
      debugPrint("$e");
      debugPrintStack(stackTrace: st);
    }
    return null;
  }
}

class LoginResult {
  final WeteamUser? user;
  final bool isSuccess;
  final bool isNewUser;

  const LoginResult({required this.isSuccess, this.isNewUser = false, this.user});
}