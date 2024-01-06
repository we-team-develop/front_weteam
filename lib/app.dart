import 'package:flutter/material.dart';
import 'package:front_weteam/controller/bottom_nav_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/view/home/home.dart';
import 'package:front_weteam/view/my/mypage.dart';
import 'package:front_weteam/view/teamplay/teamplay.dart';
import 'package:get/get.dart';

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
      height: MediaQuery.of(context).size.height * 0.080,
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
        selectedItemColor: const Color(0xFFE2583E),
        unselectedItemColor: const Color(0xFF999999),
        selectedLabelStyle: const TextStyle(fontSize: 8),
        unselectedLabelStyle: const TextStyle(fontSize: 8),
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: ImageData(path: ImagePath.tpOff, width: 80, height: 80),
              activeIcon:
                  ImageData(path: ImagePath.tpOn, width: 80, height: 80),
              label: '진행팀플'),
          BottomNavigationBarItem(
              icon: ImageData(path: ImagePath.homeOff, width: 80, height: 80),
              activeIcon:
                  ImageData(path: ImagePath.homeOn, width: 80, height: 80),
              label: '홈'),
          BottomNavigationBarItem(
              icon: ImageData(path: ImagePath.myOff, width: 80, height: 80),
              activeIcon:
                  ImageData(path: ImagePath.myOn, width: 80, height: 80),
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
