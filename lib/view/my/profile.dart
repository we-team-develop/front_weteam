import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/profile_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:front_weteam/view/login/login_main.dart';
import 'package:front_weteam/view/widget/custom_switch.dart';
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
          const ProfileImageSelectContainerWidget(),
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
            child: GetBuilder<ProfileController>(
                init: ProfileController(),
                builder: (controller) {
                  return Container(
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.textController,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '티미대 벌집조형학과',
                                  hintStyle: TextStyle(
                                    fontFamily: 'NanumGothic',
                                    fontSize: 14.sp,
                                    color: const Color(0xffc9c9c9),
                                  ),
                                  counterText: '',
                                ),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'NanumGothic',
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            Obx(() => Padding(
                                  padding: EdgeInsets.only(right: 9.0.w),
                                  child: Text(
                                    '${controller.textLength}/20',
                                    style: TextStyle(
                                      fontFamily: 'NanumGothic',
                                      fontSize: 14.sp,
                                      color: const Color(0xffc9c9c9),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
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
                    child: CustomSwitch(
                      onChanged: (value) {
                        controller.togglePushNotification(value);
                      },
                      value: controller.isPushNotificationEnabled.value,
                    ),
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
    GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => logout(),
      child:          Align(
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

  Future<void> logout() async {
    bool result = await Get.find<AuthService>().logout();
    if (result) { // 로그아웃 성공
      Get.offAll(() => const LoginMain());
    } else { // 로그아웃 실패
      Get.snackbar("죄송합니다", "로그아웃을 하지 못했습니다");
    }
  }
}
