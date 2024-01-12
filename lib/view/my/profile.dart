import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/profile_controller.dart';
import 'package:front_weteam/data/image_data.dart';
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 47.0.h),
            child: Text(
              '내 정보 관리',
              style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 17.0.h,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0.w),
              child: Text(
                '프로필 사진',
                style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF969696)),
              ),
            ),
          ),
          const ProfileImageWidget(),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0.w, top: 4.0.h),
              child: Text(
                '소속',
                style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF969696)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0.h),
            child: Container(
              width: 330.w,
              height: 39.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0.r),
                border: Border.all(
                  color: const Color(0xFFEBE9E9),
                  width: 1.w,
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 9.0.w),
                  child: Text(
                    '티미대 버섯폭탄학과',
                    style: TextStyle(
                        fontFamily: 'NanumGothic',
                        fontSize: 14.0.sp,
                        color: const Color(0xFFC9C9C9)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0.w),
              child: Text(
                '알림 설정',
                style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF969696)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0.w, top: 16.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '푸시 알림',
                    style: TextStyle(
                        fontFamily: 'NanumGothic',
                        fontSize: 15.0.sp,
                        color: const Color(0xFF333333)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15.0.w),
                    child: _pushswitch(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 34.h),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0.w),
              child: Text(
                '연결된 계정',
                style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF969696)),
              ),
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          // 연결된 계정에 따른 버튼 변경
          Image.asset(ImagePath.kakaologin, width: 330.w, height: 39.h),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0.w, top: 24.0.h),
              child: Text(
                '로그아웃',
                style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: 15.0.sp,
                    color: const Color(0xFF333333)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0.w, top: 24.0.h),
              child: Text(
                '회원탈퇴',
                style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: 15.0.sp,
                    color: const Color(0xFFE60000)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pushswitch() {
    return Obx(() => Switch(
          activeColor: const Color(0xFFFFFFFF),
          activeTrackColor: const Color(0xFFEB8673),
          inactiveTrackColor: const Color(0xFFD9D9D9),
          inactiveThumbColor: Colors.transparent,
          value: controller.isPushNotificationEnabled.value,
          onChanged: (value) {
            controller.togglePushNotification(value);
          },
        ));
  }
}
