import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller/bottom_nav_controller.dart';
import 'data/color_data.dart';
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
            spreadRadius: 10, // 그림자 확산 범위
            blurRadius: 15, // 그림자의 흐림 정도, 값이 클수록 흐릿해지면서 가장자리가 부드러워짐
            offset: const Offset(0, 8), // 그림자 위치 y축으로 아래로 1만큼 감.
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
              icon: ImageData(path: ImagePath.tpOff, width: 75.w, height: 75.h),
              activeIcon:
                  ImageData(path: ImagePath.tpOn, width: 75.w, height: 75.h),
              label: '진행팀플'),
          BottomNavigationBarItem(
              icon:
                  ImageData(path: ImagePath.homeOff, width: 75.w, height: 75.h),
              activeIcon:
                  ImageData(path: ImagePath.homeOn, width: 75.w, height: 75.h),
              label: '홈'),
          BottomNavigationBarItem(
              icon: ImageData(path: ImagePath.myOff, width: 75.w, height: 75.h),
              activeIcon:
                  ImageData(path: ImagePath.myOn, width: 75.w, height: 75.h),
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
