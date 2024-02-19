import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/image_data.dart';
import '../../main.dart';
import '../../model/team_project.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';

class TeamPlayController extends GetxController {
  final ScrollController tpScrollController = ScrollController();
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

  void tpScrollUp() {
    tpScrollController.animateTo(0,
        duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
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
        .getTeamProjectList(
            0, false, 'DESC', 'DONE', Get.find<AuthService>().user.value!.id,
            cacheKey: SharedPreferencesKeys.teamProjectNotDoneListJson);
    if (result != null && !listEquals(_oldTpList, result.projectList)) {
      _oldTpList = result.projectList;
      tpList.value = result;
    }
  }

  // tp 이미지
  RxList<String> imagePaths = RxList<String>([
    ImagePath.tpImage1,
    ImagePath.tpImage2,
    ImagePath.tpImage3,
    ImagePath.tpImage4,
    ImagePath.tpImage5,
    ImagePath.tpImage6,
    ImagePath.tpImage7,
    ImagePath.tpImage8,
    ImagePath.tpImage9,
    ImagePath.tpImage10,
  ]);
}
