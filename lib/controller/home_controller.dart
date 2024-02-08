import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/weteam_notification.dart';
import '../service/api_service.dart';

class HomeController extends GetxController {
  int teamProjectPage = 0;
  final Rxn<DDayData> dDayData = Rxn<DDayData>();
  final Rxn<GetTeamProjectListResult> tpList = Rxn<GetTeamProjectListResult>();
  final RxBool hasNewNoti = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    tpListUpdateRequiredListenerList.add(updateTeamProjectList);
    updateDDay();
    checkNotification();

    String? tpListCache = sharedPreferences.getString(SharedPreferencesKeys.teamProjectListJson);
    if (tpListCache != null) {
      tpList.value = GetTeamProjectListResult.fromJson(jsonDecode(tpListCache));
    }
  }

  Future<void> checkNotification() async {
    List<WeteamNotification>? list = await Get.find<ApiService>().getAlarms(0);
    if (list != null && list.isNotEmpty) {
      hasNewNoti.value = !list[0].read;
    } else {
      hasNewNoti.value = false;
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
  }
  
  Future<void> updateTeamProjectList() async {
    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(teamProjectPage, false, 'DESC', 'DONE', Get.find<AuthService>().user.value!.id,
            cacheKey: SharedPreferencesKeys.teamProjectListJson);
    if (result != null) {
      tpList.value = result;
    }
  }

/*  bool isTeamListEmpty() {
    return true; // false면 팀플 리스트 예시를 표시
  }*/

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