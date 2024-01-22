import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_weteam/main.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final Rxn<DDayData> dDayData = Rxn<DDayData>();

  @override
  void onInit() {
    super.onInit();
    updateDDay();
  }

  bool hasNewNotification() {
    return false;
  }

  void updateDDay() {
    String? json = sharedPreferences.getString(SharedPreferencesKeys.dDayData);
    if (json == null) {
      this.dDayData.value = null;
      return;
    }

    Map data = jsonDecode(json);
    DDayData dDayData = DDayData.fromJson(data);
    this.dDayData.value = dDayData;
  }

  bool isTeamListEmpty() {
    return true; // false면 팀플 리스트 예시를 표시
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

class DDayData {
  final DateTime start;
  final DateTime end;
  final String name;

  const DDayData({required this.start, required this.end, required this.name});

  factory DDayData.fromJson(Map data) {
    String name = data['name'];
    Map start = data['start'];
    Map end = data['end'];
    DateTime startTime = DateTime(start['year'], start['month'], start['day']);
    DateTime endTime = DateTime(end['year'], end['month'], end['day']);
    return DDayData(start: startTime, end: endTime, name: name);
  }
}