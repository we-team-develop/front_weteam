import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/team_project.dart';
import '../service/api_service.dart';
import '../service/auth_service.dart';

class TeamPlayController extends GetxController {
  final Rxn<GetTeamProjectListResult> tpList = Rxn<GetTeamProjectListResult>();
  List<TeamProject> _oldTpList = [];

  @override
  void onInit() {
    if (Get.find<AuthService>().user.value != null) {
      updateTeamProjectList();
    }
    tpListUpdateRequiredListenerList.add(updateTeamProjectList);
    super.onInit();
  }

  String getUserName() {
    return Get.find<AuthService>().user.value?.username ?? "";
  }

  Future<void> updateTeamProjectList() async {
    String? json = sharedPreferences
        .getString(SharedPreferencesKeys.teamProjectNotDoneListJson);
    if (json != null) {
      tpList.value = GetTeamProjectListResult.fromJson(jsonDecode(json));
      _oldTpList = tpList.value!.projectList;
    }

    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(0, false, 'DESC', 'DONE', Get.find<AuthService>().user.value!.id,
            cacheKey: SharedPreferencesKeys.teamProjectNotDoneListJson);
    if (result != null && !listEquals(_oldTpList, result.projectList)) {
      _oldTpList = result.projectList;
      tpList.value = result;
    }
  }
}
