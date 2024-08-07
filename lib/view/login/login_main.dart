import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../../main.dart';
import '../../model/login_result.dart';
import '../../service/auth_service.dart';
import '../../util/helper/apple_auth_helper.dart';
import '../../util/helper/auth_helper.dart';
import '../../util/helper/google_auth_helper.dart';
import '../../util/helper/kakao_auth_helper.dart';
import '../../util/helper/naver_auth_helper.dart';
import '../../util/weteam_utils.dart';
import '../widget/loading_overlay.dart';
import 'sign_up_completed.dart';

class LoginMain extends StatelessWidget {
  final Rxn<OverlayEntry> _overlayEntry = Rxn<OverlayEntry>();

  LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    var padding = 4.h; // 버튼 사이 패딩

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                ImagePath.bigWeteamTimiIcon,
                width: 108.w,
                height: 140.h,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => login(GoogleAuthHelper(), context),
                child: Image.asset(
                  ImagePath.googleLogin,
                  width: 302.w,
                  height: 39.h,
                ),
              ),
              SizedBox(height: padding),
              Visibility(
                visible: Platform.isIOS,
                  child: Column(
                children: [
                  GestureDetector(
                    onTap: () => login(AppleAuthHelper(), context),
                    child: Image.asset(
                      ImagePath.appleLogin,
                      width: 302.w,
                      height: 39.h,
                    ),
                  ),
                  SizedBox(height: padding),
                ],
              )),
              GestureDetector(
                child: Image.asset(
                  ImagePath.naverLogin,
                  width: 302.w,
                  height: 39.h,
                ),
                onTap: () => login(NaverAuthHelper(), context),
              ),
              SizedBox(height: padding),
              GestureDetector(
                onTap: () => login(KakaoAuthHelper(), context),
                child: Image.asset(
                  ImagePath.kakaoLogin,
                  width: 302.w,
                  height: 39.h,
                ),
              ),
              SizedBox(height: padding),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            ],
          ),
        ],
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    _overlayEntry.value = OverlayEntry(
        builder: (context) => const LoadingOverlay(title: "로그인 중입니다"));
    Overlay.of(context).insert(_overlayEntry.value!);
  }

  void login(AuthHelper helper, BuildContext context) async {
    try {
      _showOverlay(context);
      // TODO: 로그인 버튼 중복 클릭 방지
      LoginResult result = await Get.find<AuthService>().login(helper);
      if (result.isSuccess) {
        sharedPreferences.setBool(
            SharedPreferencesKeys.isRegistered, !result.isNewUser);
        if (result.isNewUser) {
          Get.offAll(() => const SignUpCompleted());
        } else {
          resetApp();
        }
      } else {
        WeteamUtils.snackbar("", "로그인에 실패했어요", icon: SnackbarIcon.fail);
      }
    } catch (e) {
      log("$e");
      WeteamUtils.snackbar("", "로그인 중 오류가 발생했어요", icon: SnackbarIcon.fail);
    }
    _overlayEntry.value?.remove();
    _overlayEntry.value = null;
  }
}