import 'package:flutter/material.dart';
import 'package:front_weteam/controller/naver_login_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:get/get.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    var padding = MediaQuery.of(context).size.height * 0.01;
    var horizontalPadding = MediaQuery.of(context).size.width * 0.06;
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Image.asset(ImagePath.kakaologin),
              ),
              SizedBox(height: padding),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Image.asset(ImagePath.naverlogin),
                ),
                onTap: () async {
                  NaverLoginController nlc = NaverLoginController();
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Image.asset(ImagePath.applelogin),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            ],
          ),
        ],
      ),
    );
  }
}
