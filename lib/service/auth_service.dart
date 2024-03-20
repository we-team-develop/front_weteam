import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/login_result.dart';
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
  RxString currentLoginService = ''.obs;

  @override
  void onInit() {
    dynamic firebaseIdToken = MemCache.get(MemCacheKey.firebaseAuthIdToken);
    dynamic userJson = MemCache.get(MemCacheKey.weteamUserJson);

    // 로그인 정보가 있는지 확인합니다.
    // 만약 있다면, 로그인이 된 상태로 간주합니다.
    if (firebaseIdToken != null && userJson != null) {
      token = firebaseIdToken;
      // 토큰 디버그용 로깅
      log("$token");
      // 위팀 유저 데이터를 로드합니다.
      user.value = WeteamUser.fromJson(jsonDecode(userJson));

      // 프로필이 있는지 확인합니다.
      // 만약, 프로필 데이터가 없다면 정상적인 로그인이 아니거나, 데이터가 손상되었거나,
      // 회원가입이 완료된 상태가 아닐 수 있기에 로그인 상태를 해제합니다.
      if (user.value!.profile == null) {
        user.value = null; // 로그인 취소
        return;
      }

      // 어떤 플랫폼으로 로그인되었는지 확인하기 위해 firebase uid를 불러옵니다.
      // 또한, 로그인 핼퍼를 초기화합니다.
      String uid = FirebaseAuth.instance.currentUser!.uid;
      if (uid.startsWith('naver')) {
        helper = NaverAuthHelper();
        currentLoginService.value = "네이버";
      } else if (uid.startsWith('kakao')) {
        helper = KakaoAuthHelper();
        currentLoginService.value = "카카오";
      } else {
        helper = GoogleAuthHelper();
        currentLoginService.value = "구글";
      }
    }

    // 서버에서 현재 유저 정보를 비동기로 불러와서 업데이트합니다.
    Get.put(ApiService());
    Get.find<ApiService>().getCurrentUser().then((value) {
      if (value != null) user.value = value;
    });

    super.onInit();
  }

  /// 로그인 메소드
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
    } catch (e) {
      debugPrint("로그인 실패: $e");
      return const LoginResult(isSuccess: false);
    }
  }

  /// 유저 로그아웃 메소드
  /// 로그아웃시 SharedPreferenced의 데이터가 모두 초기화됩니다!!
  /// ㄷ그에따라 D-Day 데이터도 삭제됩니다.
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
    } catch (e, st) {
      debugPrint("로그아웃 중 예외발생: $e");
      debugPrintStack(stackTrace: st);
      return false;
    }
  }

  /// 로그인 상태인지 확인하는 메소드
  Future<bool> isLoggedIn() async {
    try {
      if (helper == null) return false;
      return await helper!.isLoggedIn();
    } catch (e) {
      debugPrint("로그인 상태 확인 중 예외발생: $e");
      return false;
    }
  }

  /// 회원 탈퇴를 시도하는 메소드
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
