import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../widget/normal_button.dart';
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
      backgroundColor: AppColors.white,
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
              fontFamily: 'NanumGothicExtraBold',
              fontSize: 14.0.sp,
          ),
        ),
        const Expanded(child: SizedBox()),
        // 다음 버튼
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: NormalButton(
              onTap: () => Get.to(() => ProfileSettingPage()),
              text: '다음',
            )),
        SizedBox(height: 32.h)
      ],
    );
  }
}
