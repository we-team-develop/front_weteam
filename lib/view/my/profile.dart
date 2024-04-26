import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controller/profile_controller.dart';
import '../../data/color_data.dart';
import '../../data/image_data.dart';
import '../../main.dart';
import '../../service/auth_service.dart';
import '../../util/weteam_utils.dart';
import '../dialog/custom_check_dialog.dart';
import '../widget/custom_switch.dart';
import '../widget/profile_image_widget.dart';

class Profile extends GetView<ProfileController> {
  const Profile({super.key});

  @override
  StatelessElement createElement() {
    controller.updateOrganization();
    controller.selectProfile(
        Get.find<AuthService>().user.value!.profile?.imageIdx ?? 0);
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 47.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 대칭 공간 용
                SizedBox(
                  width: 62.w,
                  height: 25.h,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '내 정보 관리',
                      style: TextStyle(
                          fontFamily: 'NanumGothic',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // 저장 버튼
                Container(
                  width: 62.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: const Color(0xFFD9D9D9),
                  ),
                  child: Center(
                    child: Text(
                      '저장',
                      style: TextStyle(
                          fontFamily: 'NanumGothicExtraBold', fontSize: 12.sp),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 17.0.h),
            Text(
              '프로필 사진',
              style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.G_04),
            ),
            const ProfileImageSelectContainerWidget(),
            SizedBox(height: 4.0.h),
            Text(
              '소속',
              style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.G_04),
            ),
            SizedBox(height: 4.0.h),
            Container(
              width: 330.w,
              height: 39.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0.r),
                border: Border.all(
                  color: AppColors.G_01,
                  width: 1.0.w,
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
                          controller:
                              controller.organizationTextEditingController,
                          onTapOutside: (v) {
                            // 다른 곳 터치시 키보드 숨김
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          maxLength: 20,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '티미대 벌집조형학과',
                            hintStyle: TextStyle(
                              fontFamily: 'NanumGothic',
                              fontSize: 14.sp,
                              color: AppColors.G_06,
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
                                color: AppColors.G_06,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              '알림 설정',
              style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.G_04),
            ),
            SizedBox(height: 16.0.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '푸시 알림',
                  style: TextStyle(
                      fontFamily: 'NanumGothic',
                      fontSize: 15.0.sp,
                      color: AppColors.Black),
                ),
                CustomSwitch(
                  onChanged: toggleAlarmSwitch,
                  value: controller.isPushNotificationEnabled.value,
                ),
              ],
            ),
            SizedBox(height: 34.h),
            Text(
              '연결된 계정',
              style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.G_04),
            ),
            SizedBox(height: 14.h),
            // TODO: 연결된 계정에 따른 버튼 변경
            Obx(() {
              // AuthService의 인스턴스를 얻습니다.
              final AuthService authService = Get.find<AuthService>();

              String imagePath = ImagePath.loggedInGoogle; // 기본 이미지

              // authService 인스턴스를 통해 currentLoginService에 접근하여 케이스별로 이미지 경로를 설정
              switch (authService.currentLoginService.value) {
                case '네이버':
                  imagePath = ImagePath.loggedInNaver; // 네이버 로그인 이미지 경로
                  break;
                case '카카오':
                  imagePath = ImagePath.loggedInKakao; // 카카오 로그인 이미지 경로
                  break;
                case '구글':
                  imagePath = ImagePath.loggedInGoogle; // 구글 로그인 이미지 경로
                  break;
                case '애플':
                  imagePath = ImagePath.loggedInApple; // 애플 로그인 이미지 경로
                  break;
              }

              // 설정된 imagePath를 사용하여 Image.asset 위젯을 반환
              return Image.asset(imagePath, width: 330.w, height: 39.h);
            }),
            //Image.asset(ImagePath.kakaologin, width: 330.w, height: 39.h), 기존 코드
            SizedBox(height: 24.0.h),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                showDialog(
                    context: Get.context!,
                    builder: (BuildContext context) {
                      return CustomCheckDialog(
                        title: "정말 로그아웃 하시겠습니까?",
                        content: "다시 돌아올 거라 믿어요😢",
                        denyName: '아니오',
                        admitName: '로그아웃',
                        denyCallback: () {
                          Get.back();
                        },
                        admitCallback: () async {
                          await logout();
                        },
                      );
                    });
              },
              child: Text(
                '로그아웃',
                style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.Black),
              ),
            ),
            SizedBox(height: 16.0.h),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                showDialog(
                    context: Get.context!,
                    builder: (BuildContext context) {
                      return CustomCheckDialog(
                        title: "정말 탈퇴하겠습니까?",
                        content: "위팀과 함께한 모든 추억이 사라집니다😢",
                        denyName: '취소',
                        admitName: '탈퇴',
                        denyCallback: () {
                          Get.back();
                        },
                        admitCallback: () async {
                          await withdrawal();
                        },
                      );
                    });
              },
              child: Text(
                '회원탈퇴',
                style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.Red),
              ),
            ),
            SizedBox(height: 20.h)
          ],
        ),
      ),
    );
  }

  Future<void> withdrawal() async {
    bool result = await Get.find<AuthService>().withdrawal();
    if (result) {
      // 탈퇴 성공
      resetApp();
    } else {
      // 탈퇴 실패
      WeteamUtils.snackbar("탈퇴하지 못했습니다", "호스트인 팀플이 있거나 오류가 발생했습니다",
          icon: SnackbarIcon.fail);
    }
  }

  Future<void> logout() async {
    bool result = await Get.find<AuthService>().logout();
    if (result) {
      // 로그아웃 성공
      resetApp();
    } else {
      // 로그아웃 실패
      WeteamUtils.snackbar("로그아웃 실패", "오류가 있었습니다", icon: SnackbarIcon.fail);
    }
  }

  Future<void> toggleAlarmSwitch(bool v) async {
    if (v) {
      // 비활성화 하기
      controller.togglePushNotification(false);
    } else {
      // 활성화 하기
      // 알림 권한
      PermissionStatus notificationStatus =
          await Permission.notification.status;
      if (!notificationStatus.isGranted) {
        // 권한 받기 시도
        PermissionStatus newStatus = await Permission.notification.request();
        if (newStatus.isGranted) {
          controller.togglePushNotification(true);
        } else {
          WeteamUtils.snackbar('', '알림 권한이 거부되었어요.', icon: SnackbarIcon.fail);
        }
      } else {
        controller.togglePushNotification(true);
      }
    }
  }
}
