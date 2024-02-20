import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/team_project.dart';
import '../model/weteam_project_user.dart';
import '../service/api_service.dart';
import '../util/weteam_utils.dart';
import '../view/dialog/custom_check_dialog.dart';

class TeamProjectDetailPageController extends GetxController {
  late final Rx<TeamProject> tp;
  RxList<WeteamProjectUser> userList = RxList<WeteamProjectUser>();
  RxList<Widget> userContainerList = RxList<Widget>();
  RxBool isKickMode = RxBool(false);
  Rxn<WeteamProjectUser> selectedKickUser = Rxn<WeteamProjectUser>();
  RxBool isChangeHostMode = RxBool(false);
  Rx<int> selectedNewHost = Rx<int>(-1);

  TeamProjectDetailPageController(TeamProject team) {
    tp = team.obs;
    fetchUserList();
    isChangeHostMode.listen((p0) {
      if (p0 == false) selectedNewHost.value = -1; // 호스트 변경모드 꺼지면 -1로 초기화
    });

    Timer.periodic(const Duration(seconds: 30), (timer) {
      try {
        fetchTeamProject();
      } catch (_) {};
    });
  }

  Future<void> fetchTeamProject() async {
    ApiService service = Get.find<ApiService>();
    TeamProject? tp = await service.getTeamProject(this.tp.value.id);
    if (tp != null) {
      this.tp.value = tp;
    }
  }

  // 성공 여부 반환
  Future<bool> fetchUserList() async {
    List<WeteamProjectUser>? list = await Get.find<ApiService>().getProjectUsers(tp.value.id);
    if (list == null || list.isEmpty) return false; // 비어있으면 서버 오류로 판단

    userList.clear();
    userList.addAll(list);
    return true;
  }

  void showChangeHostDialog() {
    if (selectedNewHost.value == -1) {
      WeteamUtils.snackbar('','호스트 권한을 받을 유저를 선택해주세요');
      return;
    }

    showDialog(
        context: Get.context!,
        builder: (context) => CustomCheckDialog(
          title: '',
          content: '정말 호스트를 넘길까요?',
          admitCallback: changeHost,
          denyCallback: () async {
            await WeteamUtils.closeSnackbarNow();
            Get.back();
          },
        ));
  }

  Future<void> changeHost() async {
    bool success = await Get.find<ApiService>()
        .changeTeamProjectHost(tp.value.id, selectedNewHost.value);
    if (success) {
      await updateTeamProjectLists();
      isChangeHostMode.value = false;
      Get.back();
      WeteamUtils.snackbar("","호스트 권한을 성공적으로 넘겼습니다", icon: SnackbarIcon.success);
    } else {
      WeteamUtils.snackbar("호스트 변경 실패", "오류가 발생했습니다", icon: SnackbarIcon.fail);
    }
  }
  
  void showKickDialog() {
    if (selectedKickUser.value == null) {
      WeteamUtils.snackbar("", "퇴출시킬 유저를 선택하세요");
      return;
    }
    WeteamProjectUser selectedUser = selectedKickUser.value!;
    showDialog(
        context: Get.context!,
        builder: (context) => CustomCheckDialog(
            title: '',
            content: '정말 ${selectedUser.user.username}님을 강제 퇴장시킬까요?',
          admitCallback: kickSelectedUser,
          denyCallback: () async {
              await WeteamUtils.closeSnackbarNow();
              Get.back();
          },
        ));
  }

  Future<void> kickSelectedUser() async {
    ApiService service = Get.find<ApiService>();
    bool success = await service.kickUserFromTeamProject([selectedKickUser.value!.id]);

    if (success) {
      WeteamUtils.snackbar("", "성공적으로 퇴출시켰습니다.", icon: SnackbarIcon.success);
      fetchUserList();
      isKickMode.value = false;
    } else {
      WeteamUtils.snackbar("강제 퇴장 실패", "오류가 발생했습니다", icon: SnackbarIcon.fail);
    }
  }
}