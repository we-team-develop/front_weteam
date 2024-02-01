import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../model/team_project.dart';
import '../model/weteam_project_user.dart';
import '../service/api_service.dart';

class TeamProjectDetailPageController extends GetxController {
  late final Rx<TeamProject> tp;
  RxList<WeteamProjectUser> userList = RxList<WeteamProjectUser>();
  RxList<Widget> userContainerList = RxList<Widget>();
  RxBool isKickMode = RxBool(false);
  RxBool isChangeHostMode = RxBool(false);
  Rx<int> selectedNewHost = Rx<int>(-1);

  TeamProjectDetailPageController(TeamProject team) {
    tp = team.obs;
    fetchUserList();
    isChangeHostMode.listen((p0) {
      if (p0 == false) selectedNewHost.value = -1; // 호스트 변경모드 꺼지면 -1로 초기화
    });
  }

  // 성공 여부 반환
  Future<bool> fetchUserList() async {
    List<WeteamProjectUser>? list = await Get.find<ApiService>().getProjectUsers(tp.value.id);
    if (list == null || list.isEmpty) return false; // 비어있으면 서버 오류로 판단

    userList.clear();
    userList.addAll(list);
    return true;
  }
}