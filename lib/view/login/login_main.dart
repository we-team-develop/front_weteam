import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/app.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/main.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:front_weteam/util/helper/auth_helper.dart';
import 'package:front_weteam/util/helper/google_auth_helper.dart';
import 'package:front_weteam/util/helper/kakao_auth_helper.dart';
import 'package:front_weteam/util/helper/naver_auth_helper.dart';
import 'package:front_weteam/view/login/sign_up_completed.dart';
import 'package:get/get.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    var padding = MediaQuery.of(context).size.height * 0.01; // 버튼 사이 패딩

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                ImagePath.appicon,
                width: 110.w,
                height: 140.h,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => login(GoogleAuthHelper()),
                child: Image.asset(
                  ImagePath.googlelogin,
                  width: 302.w,
                  // height: 39.h,
                ),
              ),
              SizedBox(height: padding),
              GestureDetector(
                onTap: () => login(KakaoAuthHelper()),
                child: Image.asset(
                  ImagePath.kakaologin,
                  width: 302.w,
                  height: 39.h,
                ),
              ),
              SizedBox(height: padding),
              GestureDetector(
                child: Image.asset(
                  ImagePath.naverlogin,
                  width: 302.w,
                  height: 39.h,
                ),
                onTap: () => login(NaverAuthHelper()),
              ),
              SizedBox(height: padding),
              // 임시 회원
              GestureDetector(
                onTap: () {
                  Get.to(() => const SignUpCompleted());
                },
                child: Image.asset(
                  ImagePath.applelogin,
                  width: 302.w,
                  height: 39.h,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            ],
          ),
        ],
      ),
    );
  }

  void login(AuthHelper helper) async {
    // TODO: 로그인 버튼 중복 클릭 방지
    LoginResult result = await Get.find<AuthService>().login(helper);
    if (result.isSuccess) {
      sharedPreferences.setBool(SharedPreferencesKeys.isRegistered, !result.isNewUser);
      if (result.isNewUser) {
        Get.offAll(() => const SignUpCompleted());
      } else {
        Get.offAll(() => const App());
      }
    } else {
      Get.snackbar("로그인 실패", "로그인에 실패하였습니다");
    }
  }
}
