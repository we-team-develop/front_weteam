import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/google_login_controller.dart';
import 'package:front_weteam/controller/login_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/util/api_service.dart';
import 'package:get/get.dart';
import 'package:front_weteam/view/login/sign_up_completed.dart';

class LoginMain extends GetView<LoginController> {
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
              InkWell(
                onTap: () {
                  GoogleLoginController().signInWithGoogle();
                },
                child: Image.asset(
                  ImagePath.googlelogin,
                  width: 302.w,
                  height: 39.h,
                ),
              ),
              SizedBox(height: padding),
              GestureDetector(
                onTap: () {
                  Get.find<LoginController>().loginKakao((isSuccess) {
                    if (isSuccess) {
                      FirebaseAuth.instance.currentUser
                          ?.getIdToken()
                          .then((idToken) {
                        // 백엔드에 보낼 idToken -> 이걸로 인증하세요
                        print(idToken);
                        print("로그인 성공!");
                      });
                    }
                  });
                },
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
                onTap: () async {
                  ApiService nlc = ApiService();
                  bool success = await nlc.login();

                  bool isFirstLogin = true; // TODO: 첫번째 로그인인지 확인하는 로직 구현
                  // Get.to(회원가입 축하)
                  Get.snackbar("네이버 로그인", success ? "성공" : "실패");
                  if (success) {
                    Get.snackbar("네이버 토큰 ", await nlc.getToken());
                  }
                },
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
}
