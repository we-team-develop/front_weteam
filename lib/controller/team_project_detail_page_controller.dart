import 'package:flutter/widgets.dart';
import 'package:front_weteam/data/color_data.dart';
import 'package:front_weteam/main.dart';
import 'package:get/get.dart';

import '../model/team_project.dart';
import '../model/weteam_project_user.dart';
import '../service/api_service.dart';

class TeamProjectDetailPageController extends GetxController {
  late final Rx<TeamProject> tp;
  RxList<WeteamProjectUser> userList = RxList<WeteamProjectUser>();
  RxList<Widget> userContainerList = RxList<Widget>();
  RxBool isKickMode = RxBool(false);
  Rx<int> selectedKickUser = Rx<int>(-1);
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

  Future<void> changeHost() async {
    if (selectedNewHost.value == -1) {
      Get.snackbar("호스트 권한을 넘길 수 없습니다", '호스트 권한을 받을 유저를 선택해주세요');
      return;
    }

    bool success = await Get.find<ApiService>()
        .changeTeamProjectHost(tp.value.id, selectedNewHost.value);
    if (success) {
      await updateTeamProjectLists();
      isChangeHostMode.value = false;
      Get.back();
      Get.snackbar("호스트 변경 성공", "호스트 권한을 성공적으로 넘겼습니다");
    } else {
      Get.snackbar("호스트 변경 실패", "오류가 발생했습니다");
    }
  }

  Future<void> kickSelectedUser() async {
    ApiService service = Get.find<ApiService>();
    if (selectedKickUser.value == -1) {
      Get.snackbar("퇴출시킬 유저를 선택하세요", "", backgroundColor: AppColors.Red.withOpacity(0.2));
      return;
    }
    bool success = await service.kickUserFromTeamProject([selectedKickUser.value]);

    if (success) {
      Get.snackbar("강제 퇴장 성공", "성공적으로 퇴출시켰습니다.");
      fetchUserList();
      isKickMode.value = false;
    } else {
      Get.snackbar("강제 퇴장 실패", "오류가 발생했습니다");
    }
  }
}