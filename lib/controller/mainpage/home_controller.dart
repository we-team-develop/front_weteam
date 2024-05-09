import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../model/team_project.dart';
import '../../model/weteam_alarm.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../service/team_project_service.dart';
import '../../view/widget/team_project_widget.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final Rxn<DDayData> dDayData = Rxn<DDayData>();
  final Rxn<List<Widget>> tpWidgetList = Rxn<List<Widget>>();
  final RxBool hasNewAlarm = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    tpListUpdateRequiredListenerList.add(updateTeamProjectList);
    updateDDay();
    checkNewAlarm();

    String? tpListCache =
        sharedPreferences.getString(SharedPreferencesKeys.teamProjectListJson);
    if (tpListCache != null) {
      GetTeamProjectListResult gtplResult =
          GetTeamProjectListResult.fromJson(jsonDecode(tpListCache));
      tpWidgetList.value = _generateTpwList(gtplResult);
      tpWidgetList.refresh();
    }

    Get.find<ApiService>().setFCMToken();
  }

  void scrollUp() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
  }

  List<Widget> _generateTpwList(GetTeamProjectListResult result) {
    List<RxTeamProject> rxTpList = result.rxProjectList;
    EdgeInsets padding = EdgeInsets.only(bottom: 12.h);
    return List<Widget>.generate(
        rxTpList.length,
        (index) =>
            Padding(padding: padding, child: TeamProjectWidget(rxTpList[index])));
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

  Future<void> updateTeamProjectList() async {
    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(
            0, false, 'DESC', 'DONE', Get.find<AuthService>().user.value!.id,
            cacheKey: SharedPreferencesKeys.teamProjectListJson);

    if (result != null) {
      tpWidgetList.value = _generateTpwList(result);
      tpWidgetList.refresh();
    }
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
