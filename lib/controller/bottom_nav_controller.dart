import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'mainpage/home_controller.dart';
import 'mainpage/my_page_controller.dart';
import 'mainpage/tp_controller.dart';

enum Page { project, home, myPage }

class BottomNavController extends GetxController {
  final RxInt _pageIndex = 1.obs;

  final List<int> _history = [0];

  int get index => _pageIndex.value;

  /// 페이지의 인덱스를 변경하는 메소드
  /// 설정될 인덱스랑 현재 인덱스가 같다면, 화면을 최상단으로 스크롤합니다.
  void changeIndex(int pageIndex) {
    var page = Page.values[pageIndex];
    try {
      if (pageIndex == _pageIndex.value) {
        switch (page) {
          case Page.project:
            Get.find<TeamPlayController>().tpScrollUp();
            break;
          case Page.home:
            Get.find<HomeController>().scrollUp();
            break;
          case Page.myPage:
            Get.find<MyPageController>().scrollUp();
            break;
        }
      }
    } catch (_) {}

    // 페이지 이동
    _moveToPage(pageIndex);
  }

  void _moveToPage(int value) {
    if (_history.last != value && Platform.isAndroid) {
      _history.add(value);
      debugPrint(_history.toString());
    }
    _pageIndex(value);
  }

  Future<bool> popAction() async {
    //뒤로가기 두 번 해야 종료
    if (_history.length == 1) {
      return true;
    } else {
      _history.removeLast();
      _pageIndex(_history.last);
      return false;
    }
  }
}
