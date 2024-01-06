import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  bool hasNewNotification() {
    return false;
  }

  bool hasFixedDDay() {
    return false; // DDAY 예시 표시 여부
  }

  bool isTeamListEmpty() {
    return true; // true면 팀플 리스트 예시를 표시
  }

  Map? getDDay() {
    return {
      'name': '모션그래픽 1차 마감일까지',
      'leftDays': 1
    };
  }

  void popupDialog(Widget dialogWidget) { // TODO: 이게 여기 있어도 되나요
    showDialog(
        context: Get.context!,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        //barrierDismissible: false,
        builder: (BuildContext context) {
          return dialogWidget;
        });
  }
}
