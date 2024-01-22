import 'dart:convert';

import 'package:get/get.dart';

import '../main.dart';
import '../service/api_service.dart';
import '../service/auth_service.dart';

class MyController extends GetxController {
  final Rxn<GetTeamProjectListResult> tpList = Rxn<GetTeamProjectListResult>();

  @override
  void onInit() {
    updateTeamProjectList();

    super.onInit();
  }

  String getUserName() {
    return Get.find<AuthService>().user.value?.username ?? "";
  }

  Future<void> updateTeamProjectList() async {
    String? json = sharedPreferences.getString(SharedPreferencesKeys.teamProjectDoneListJson);
    if (json != null) {
      tpList.value = GetTeamProjectListResult.fromJson(jsonDecode(json));
    }

    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(0, true, 'DESC', 'DONE',
            cacheKey: SharedPreferencesKeys.teamProjectDoneListJson);
    if (result != null) {
      tpList.value = result;
    }
  }
}
