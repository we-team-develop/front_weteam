import 'dart:convert';

import 'package:get/get.dart';

import '../main.dart';
import '../service/api_service.dart';
import '../service/auth_service.dart';

class TeamPlayController extends GetxController {
  final Rxn<GetTeamProjectListResult> tpList = Rxn<GetTeamProjectListResult>();

  @override
  void onInit() {
    updateTeamProjectList();
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
    }

    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(0, false, 'DESC', 'DONE',
            cacheKey: SharedPreferencesKeys.teamProjectNotDoneListJson);
    if (result != null) {
      tpList.value = result;
    }
  }
}
