import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../model/team_project.dart';
import '../../model/weteam_notification.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../view/widget/team_project_widget.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int teamProjectPage = 0;
  final Rxn<DDayData> dDayData = Rxn<DDayData>();
  final Rxn<List<Widget>> tpWidgetList = Rxn<List<Widget>>();
  final RxBool hasNewNoti = RxBool(false);

  List<TeamProject> oldTpList = [];

  @override
  void onInit() {
    super.onInit();
    tpListUpdateRequiredListenerList.add(updateTeamProjectList);
    updateDDay();
    checkNotification();

    String? tpListCache =
        sharedPreferences.getString(SharedPreferencesKeys.teamProjectListJson);
    if (tpListCache != null) {
      GetTeamProjectListResult gtplResult =
          GetTeamProjectListResult.fromJson(jsonDecode(tpListCache));
      oldTpList = gtplResult.projectList;
      tpWidgetList.value = _generateTpwList(gtplResult);
      tpWidgetList.refresh();
    }
  }

  void scrollUp() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
  }

  List<Widget> _generateTpwList(GetTeamProjectListResult result) {
    List<TeamProject> tpList = result.projectList;
    EdgeInsets padding = EdgeInsets.only(bottom: 12.h);
    return List<Widget>.generate(
        tpList.length,
        (index) =>
            Padding(padding: padding, child: TeamProjectWidget(tpList[index])));
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
        .getTeamProjectList(teamProjectPage, false, 'DESC', 'DONE',
            Get.find<AuthService>().user.value!.id,
            cacheKey: SharedPreferencesKeys.teamProjectListJson);
    if (result != null && !listEquals(oldTpList, result.projectList)) {
      oldTpList = result.projectList;
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
