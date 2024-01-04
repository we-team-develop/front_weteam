import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front_weteam/controller/login_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/social/kakao.dart';
import 'package:front_weteam/view/login/sign_up_completed.dart';
import 'package:get/get.dart';

class LoginMain extends GetView<LoginController> {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    var padding = MediaQuery.of(context).size.height * 0.01; // 버튼 사이 패딩
    var horizontalPadding =
        MediaQuery.of(context).size.width * 0.06; // 버튼 양옆 패딩
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(ImagePath.appicon),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Image.asset(ImagePath.googlelogin),
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Image.asset(ImagePath.kakaologin),
                ),
              ),
              SizedBox(height: padding),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Image.asset(ImagePath.naverlogin),
              ),
              SizedBox(height: padding),
              // 임시 회원
              GestureDetector(
                onTap: () {
                  Get.to(() => const SignUpCompleted());
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Image.asset(ImagePath.applelogin),
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
