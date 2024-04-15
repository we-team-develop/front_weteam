import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MyPageController extends GetxController {
  final ScrollController scrollController = ScrollController();

  /// 팀플 목록을 최상단으로 스크롤합니다.
  void scrollUp() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
  }
}