import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

import 'controller/bottom_nav_controller.dart';
import 'controller/mainpage/home_controller.dart';
import 'data/color_data.dart';
import 'data/image_data.dart';
import 'service/api_service.dart';
import 'service/auth_service.dart';
import 'util/weteam_utils.dart';
import 'view/home/home.dart';
import 'view/my/mypage.dart';
import 'view/teamplay/teamplay.dart';

class App extends GetView<BottomNavController> {
  const App({super.key});

  @override
  StatelessElement createElement() {
    linkStream.listen((event) async {
      if (event == null) return;
      bool isLoggedIn = Get.find<AuthService>().user.value != null;
      Uri uri = Uri.parse(event);

      String host = uri.host;
      String path = uri.path;
      Map<String, String> query = uri.queryParameters;

      if (host == "projects") {
        if (path.startsWith("/acceptInvite")) {
          String hashedId = query['id'] ?? '-1';
          if (!isLoggedIn) return;

          bool success = await Get.find<ApiService>().acceptInvite(hashedId);
          if (success) {
            Get.find<HomeController>().updateTeamProjectList();
            WeteamUtils.snackbar("", '팀플 초대를 성공적으로 수락했어요!',
                icon: SnackbarIcon.success);
          } else {
            WeteamUtils.snackbar("", '오류가 발생하여 팀플 초대를 수락하지 못했어요.',
                icon: SnackbarIcon.fail);
          }
        }
      } else if (host == "meeting") {
        if (path.startsWith('add')) {
          int meetingId = int.parse(query['id'] ?? '-1');
          WeteamUtils.snackbar('아직 구현되지 않음', '언제보까 수락 기능을 구현하지 않았습니다.');
          // TODO: 구현하기
        }
      }
    });
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        // 뒤로가기 담당
        canPop: true,
        onPopInvoked: (didPop) {
          controller.popAction();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false, // 키보드 픽셀 over 방지
          body: SafeArea(child: _body()),
          bottomNavigationBar: _bottom(context),
        ),
      ),
    );
  }

  Widget _bottom(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // 색상
            spreadRadius: 10.r, // 그림자 확산 범위
            blurRadius: 15, // 그림자의 흐림 정도, 값이 클수록 흐릿해지면서 가장자리가 부드러워짐
            offset: Offset(0, 8.h), // 그림자 위치 y축으로 아래로 1만큼 감.
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: controller.index,
        onTap: controller.changeIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.MainOrange,
        unselectedItemColor: AppColors.G_04,
        selectedLabelStyle: TextStyle(fontSize: 8.sp),
        unselectedLabelStyle: TextStyle(fontSize: 8.sp),
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon:
              Image.asset(ImagePath.tpOff, width: 25.w, height: 25.h),
              activeIcon:
              Image.asset(ImagePath.tpOn, width: 25.w, height: 25.h),
              label: '진행팀플'),
          BottomNavigationBarItem(
              icon: Image.asset(
                  ImagePath.homeOff, width: 25.w, height: 25.h),
              activeIcon: Image.asset(
                  ImagePath.homeOn, width: 25.w, height: 25.h),
              label: '홈'),
          BottomNavigationBarItem(
              icon:
              Image.asset(ImagePath.myOff, width: 25.w, height: 25.h),
              activeIcon:
              Image.asset(ImagePath.myOn, width: 25.w, height: 25.h),
              label: '마이'),
        ],
      ),
    );
  }

  Widget _body() {
    return IndexedStack(
      index: controller.index,
      children: const [
        TeamPlay(),
        Home(),
        MyPage(),
      ],
    );
  }
}
