import 'package:flutter/material.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/view/login/profile_setting.dart';
import 'package:get/get.dart';

class SignUpCompleted extends StatefulWidget {
  const SignUpCompleted({super.key});

  @override
  State<SignUpCompleted> createState() => _SignUpCompletedState();
}

class _SignUpCompletedState extends State<SignUpCompleted> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImagePath.appicon),
              const SizedBox(
                height: 25.0,
              ),
              const Text(
                'WE TEAM 회원가입이 완료되었습니다!',
                style: TextStyle(
                  fontFamily: 'NanumGothicExtraBold',
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
        // 임시 이동 버튼
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.1),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => const ProfileSettingPage());
                },
                child: _nextpagebutton()),
          ),
        ),
      ],
    );
  }

  Widget _nextpagebutton() {
    return Container(
      width: 10,
      height: 10,
      color: Colors.black,
    );
  }
}
