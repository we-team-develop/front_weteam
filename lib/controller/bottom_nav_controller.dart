import 'dart:io';

import 'package:get/get.dart';

enum Page { TEAMPLAY, HOME, MYPAGE }

class BottomNavController extends GetxController {
  final RxInt _pageIndex = 1.obs;

  final List<int> _history = [0];

  int get index => _pageIndex.value;

  void changeIndex(int value) {
    var page = Page.values[value];
    switch (page) {
      case Page.TEAMPLAY:
      case Page.HOME:
      case Page.MYPAGE:
        moveToPage(value);
    }
  }

  void moveToPage(int value) {
    if (_history.last != value && Platform.isAndroid) {
      _history.add(value);
      print(_history);
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
