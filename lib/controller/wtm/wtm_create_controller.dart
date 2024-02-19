import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/team_project.dart';
import '../../model/weteam_user.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../util/weteam_utils.dart';

class WTMCreateController extends GetxController {
  final Rx<String> searchText = Rx("");
  String? searchWait;

  final Rxn<TeamProject> selectedTeamProject = Rxn();
  final RxList<TeamProject> tpList = RxList();
  RxString selectedTpList = '진행중인 팀플'.obs;

  final TextEditingController nameInputController = TextEditingController();
  final Rx<String> nameInputText = Rx("");

  // wtm_create.dart
  void setSelectedTpList(String tpList) {
    selectedTpList.value = tpList;
    bool done = tpList == "완료된 팀플";
    updateTeamProject(done);
    selectedTeamProject.value = null;
    selectedTeamProject.refresh();
  }

  Future<void> updateTeamProject(bool done) async {
    WeteamUser user = Get.find<AuthService>().user.value!;
    tpList.clear();
    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(0, done, 'DESC', 'DONE', user.id);

    if (result != null) {
      tpList.addAll(result.projectList);
    } else {
      WeteamUtils.snackbar('문제가 발생했습니다', '팀플 목록을 불러오지 못했습니다');
    }
  }

  void scheduleSearch(String query) {
    query = query.trim();
    searchWait = query;
    // 600ms 대기
    Timer(const Duration(milliseconds: 400), () {
      // 만약 검색어가 바뀌었다면 취소
      if (searchWait != query) return;
      searchText.value = query;
    });
  }

}