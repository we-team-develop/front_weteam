import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controller/profile_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../../main.dart';
import '../../service/auth_service.dart';
import '../../util/helper/auth_helper.dart';
import '../../util/weteam_utils.dart';
import '../dialog/custom_check_dialog.dart';
import '../widget/custom_switch.dart';
import '../widget/custom_title_bar.dart';
import '../widget/normal_button.dart';
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
      body: _body(context), // context를 _body 메서드에 전달
    );
  }

  Widget _body(BuildContext context) {
    // context 매개변수 추가
    return Column(
      children: [
        SizedBox(height: 47.h),
        Stack(
          children: [
            const CustomTitleBar(title: '내 정보 관리'),
            // 저장 버튼
            Positioned(
              right: 15.w,
                child: _saveButton())
          ],
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 17.0.h),
                // 프로필 선택
                _profileSelection(),
                SizedBox(height: 4.0.h),
                // 소속 입력
                _organization(),
                SizedBox(height: 24.h),
                // 푸시 알림
                _pushAlarm(),
                SizedBox(height: 34.h),
                // 연결된 계정
                _linkedAccount(),
                SizedBox(height: 24.0.h),
                // 로그아웃 버튼
                _logoutButton(),
                SizedBox(height: 16.0.h),
                // 회원 탈퇴 버튼
                _withdrawButton(),
                SizedBox(height: 40.h)
              ],
            ),
          ),
        ))
      ],
    );
  }

  Obx _saveButton() {
    return Obx(
      () {
        // 저장 가능 여부(변경사항이 있는가?)
        bool enable = controller.changes.value;

        return NormalButton(
          onTap: () async {
            // 변경사항 없으면 무시
            if (!enable) return;

            try {
              // 서버에 저장 시도
              await controller.saveChanges();
              // 변경사항 확인
              controller.changes.value = controller.anyChanges();

              WeteamUtils.snackbar('', '변경사항을 저장했어요',
                  icon: SnackbarIcon.success);
            } catch (e) {
              // 오류 출력
              debugPrint(e.toString());
              WeteamUtils.snackbar('', '변경사항을 저장하지 못했어요',
                  icon: SnackbarIcon.fail);
            }
          },
          width: 62.w,
          height: 25.h,
          fontSize: 12.sp,
          text: '저장',
          textStyle: TextStyle(
              fontFamily: 'NanumGothicExtraBold',
              fontSize: 12.sp,
              color: enable ? AppColors.white : AppColors.black),
          color: enable ? AppColors.mainOrange : AppColors.g2,
        );
      },
    );
  }

  GestureDetector _withdrawButton() {
    return GestureDetector(
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
                  WeteamUtils.closeDialog();
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
            color: AppColors.red),
      ),
    );
  }

  GestureDetector _logoutButton() {
    return GestureDetector(
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
                  WeteamUtils.closeDialog();
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
            color: AppColors.black),
      ),
    );
  }

  Column _linkedAccount() {
    // AuthService의 인스턴스를 얻습니다.
    final AuthService authService = Get.find<AuthService>();

    String imagePath = ImagePath.loggedInGoogle; // 기본 이미지

    // authService 인스턴스를 통해 currentLoginService에 접근하여 케이스별로 이미지 경로를 설정
    switch (authService.helper!.getProvider()) {
      case WeteamAuthProvider.naver:
        imagePath = ImagePath.loggedInNaver; // 네이버 로그인 이미지 경로
        break;
      case WeteamAuthProvider.kakao:
        imagePath = ImagePath.loggedInKakao; // 카카오 로그인 이미지 경로
        break;
      case WeteamAuthProvider.google:
        imagePath = ImagePath.loggedInGoogle; // 구글 로그인 이미지 경로
        break;
      case WeteamAuthProvider.apple:
        imagePath = ImagePath.loggedInApple; // 애플 로그인 이미지 경로
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '연결된 계정',
          style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: 14.0.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.g4),
        ),
        SizedBox(height: 14.h),
        Image.asset(imagePath, width: 330.w, height: 39.h),
      ],
    );
  }

  Column _pushAlarm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '알림 설정',
          style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: 14.0.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.g4),
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
                  color: AppColors.black),
            ),
            CustomSwitch(
              onChanged: toggleAlarmSwitch,
              value: controller.isPushNotificationEnabled.value,
            ),
          ],
        ),
      ],
    );
  }

  Column _organization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '소속',
          style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: 14.0.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.g4),
        ),
        SizedBox(height: 4.0.h),
        _organizationTextField(),
      ],
    );
  }

  Container _organizationTextField() {
    return Container(
      width: 330.w,
      height: 39.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0.r),
        border: Border.all(
          color: AppColors.g1,
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
                  controller: controller.organizationTextEditingController,
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
                      color: AppColors.g6,
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
                        color: AppColors.g6,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Column _profileSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '프로필 사진',
          style: TextStyle(
              fontFamily: 'NanumGothic',
              fontSize: 14.0.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.g4),
        ),
        const ProfileImageSelectContainerWidget(),
      ],
    );
  }

  Future<void> withdrawal() async {
    bool result = await Get.find<AuthService>().withdrawal();
    if (result) {
      // 탈퇴 성공
      resetApp();
    } else {
      // 탈퇴 실패
      WeteamUtils.snackbar("탈퇴할 수 없어요", "호스트인 팀플이 있거나 오류가 있어요",
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
      WeteamUtils.snackbar("로그아웃 실패", "오류가 발생했어요", icon: SnackbarIcon.fail);
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
          WeteamUtils.snackbar('', '알림 권한이 거부되었어요', icon: SnackbarIcon.fail);
        }
      } else {
        controller.togglePushNotification(true);
      }
    }
  }
}
