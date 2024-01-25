import 'package:flutter/widgets.dart';
import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/model/weteam_project_user.dart';
import 'package:front_weteam/service/api_service.dart';
import 'package:get/get.dart';

class TeamProjectDetailPageController extends GetxController {
  late final Rx<TeamProject> tp;
  RxList<WeteamProjectUser> userList = RxList<WeteamProjectUser>();
  RxList<Widget> userContainerList = RxList<Widget>();
  RxBool isKickMode = RxBool(false);

  TeamProjectDetailPageController(TeamProject team) {
    tp = team.obs;
    fetchUserList();
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