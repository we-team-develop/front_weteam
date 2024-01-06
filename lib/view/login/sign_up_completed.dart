import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: const Color(0xFFFFFFFF),
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
              Image.asset(
                ImagePath.appicon,
                width: 110.w,
                height: 140.h,
              ),
              SizedBox(
                height: 21.0.h,
              ),
              Text(
                'WE TEAM 회원가입이 완료되었습니다!',
                style: TextStyle(
                  fontFamily: 'NanumGothicExtraBold',
                  fontSize: 14.0.sp,
                ),
              ),
            ],
          ),
        ),
        // 다음 버튼
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 67.0.h),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => ProfileSettingPage());
                },
                child: _nextpagebutton()),
          ),
        ),
      ],
    );
  }

  Widget _nextpagebutton() {
    return Image.asset(
      ImagePath.nextButton,
      width: 330.w,
      height: 38.h,
    );
  }
}