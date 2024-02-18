import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'mainpage/home_controller.dart';
import 'mainpage/my_page_controller.dart';
import 'mainpage/tp_controller.dart';

enum Page { TEAMPLAY, HOME, MYPAGE }

class BottomNavController extends GetxController {
  final RxInt _pageIndex = 1.obs;

  final List<int> _history = [0];

  int get index => _pageIndex.value;

  void changeIndex(int value) {
    var page = Page.values[value];
    if (value == _pageIndex.value) {
      switch (page) {
        case Page.TEAMPLAY:
          Get.find<TeamPlayController>().tpScrollUp();
          break;
        case Page.HOME:
          Get.find<HomeController>().scrollUp();
          break;
        case Page.MYPAGE:
          Get.find<MyPageController>().scrollUp();
          break;
      }
    }
    moveToPage(value);
  }

  void moveToPage(int value) {
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
