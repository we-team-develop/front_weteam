import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/color_data.dart';
import '../../data/image_data.dart';
import 'profile_setting.dart';

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
      backgroundColor: AppColors.White,
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 140.h),
        Image.asset(
          ImagePath.bigWeteamTimiIcon,
          width: 108.w,
          height: 140.h,
        ),
        SizedBox(
          height: 21.0.h,
        ),
        Text(
          'WE TEAM 회원가입이 완료되었습니다!',
          style: TextStyle(
              fontFamily: 'NanumExtraGothic',
              fontSize: 14.0.sp,
              fontWeight: FontWeight.bold
          ),
        ),
        const Expanded(child: SizedBox()),
        // 다음 버튼
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
              onTap: () {
                Get.to(() => ProfileSettingPage());
              },
              child: _nextpagebutton()),
        ),
        SizedBox(height: 32.h)
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
