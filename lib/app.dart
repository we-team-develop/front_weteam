import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller/bottom_nav_controller.dart';
import 'data/app_colors.dart';
import 'data/image_data.dart';
import 'view/home/home.dart';
import 'view/my/mypage.dart';
import 'view/teamplay/teamplay.dart';

class App extends GetView<BottomNavController> {
  const App({super.key});

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
      // ios기기에서 발생하는 오버플로 현상 해결
      child: OverflowBox(
        maxHeight: double.infinity,
        child: BottomNavigationBar(
          currentIndex: controller.index,
          onTap: controller.changeIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.mainOrange,
          unselectedItemColor: AppColors.g4,
          selectedLabelStyle: TextStyle(fontSize: 8.sp),
          unselectedLabelStyle: TextStyle(fontSize: 8.sp),
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(ImagePath.tpOff, width: 25.w, height: 25.h),
                activeIcon:
                    Image.asset(ImagePath.tpOn, width: 25.w, height: 25.h),
                label: '진행팀플'),
            BottomNavigationBarItem(
                icon: Image.asset(ImagePath.homeOff, width: 25.w, height: 25.h),
                activeIcon:
                    Image.asset(ImagePath.homeOn, width: 25.w, height: 25.h),
                label: '홈'),
            BottomNavigationBarItem(
                icon: Image.asset(ImagePath.myOff, width: 25.w, height: 25.h),
                activeIcon:
                    Image.asset(ImagePath.myOn, width: 25.w, height: 25.h),
                label: '마이'),
          ],
        ),
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
