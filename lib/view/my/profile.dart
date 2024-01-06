import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/profile_controller.dart';
import 'package:front_weteam/view/widget/profile_image_widget.dart';
import 'package:get/get.dart';

class Profile extends GetView<ProfileController> {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '내 정보 관리',
          style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: 14.0.sp,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 17.0.h,
        ),
        const ProfileImageWidget(),
      ],
    );
  }
}
