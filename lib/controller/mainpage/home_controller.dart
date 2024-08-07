import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../model/weteam_alarm.dart';
import '../../service/api_service.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final Rxn<DDayData> dDayData = Rxn<DDayData>();
  final RxBool hasNewAlarm = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    updateDDay();
    checkNewAlarm();

    Get.find<ApiService>().setFCMToken();
  }

  void scrollUp() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
  }

  Future<void> checkNewAlarm() async {
    List<WeteamAlarm>? list = await Get.find<ApiService>().getAlarms(0);
    if (list != null && list.isNotEmpty) {
      hasNewAlarm.value = !list[0].read;
    } else {
      hasNewAlarm.value = false;
    }
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
    this.dDayData.refresh();
  }

/*  bool isTeamListEmpty() {
    return true; // false면 팀플 리스트 예시를 표시
  }*/

  void popupDialog(Widget dialogWidget) {
    // TODO: 이게 여기 있어도 되나요
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
