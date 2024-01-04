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
        canPop: true,
        onPopInvoked: (didPop) {
          controller.popAction();
        },
        child: Scaffold(
          body: _body(),
          bottomNavigationBar: _bottom(),
        ),
      ),
    );
  }

  Widget _bottom() {
    print('check bottom nav');
    return NavigationBar(
      selectedIndex: controller.index,
      onDestinationSelected: (index) => controller.changeIndex(index),
      destinations: [
        NavigationDestination(
          icon: ImageData(path: ImagePath.tpOff),
          selectedIcon: ImageData(path: ImagePath.tpOn),
          label: '진행팀플',
        ),
        NavigationDestination(
          icon: ImageData(path: ImagePath.homeOff),
          selectedIcon: ImageData(path: ImagePath.homeOn),
          label: '홈',
        ),
        NavigationDestination(
          icon: ImageData(path: ImagePath.myOff),
          selectedIcon: ImageData(path: ImagePath.myOn),
          label: '마이',
        ),
      ],
    );
  }

  Widget _body() {
    print('check body()');
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
