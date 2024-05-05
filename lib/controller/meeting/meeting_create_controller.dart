import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/meeting.dart';
import '../../model/team_project.dart';
import '../../model/weteam_user.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../util/weteam_utils.dart';
import '../../view/meeting/create/meeting_create_finish.dart';
import '../custom_calendar_controller.dart';
import 'meeting_controller.dart';

class MeetingCreateController extends GetxController {
  Meeting? meeting;

  final Rx<String> searchText = Rx("");
  String? searchWait;

  final Rxn<TeamProject> selectedTeamProject = Rxn();
  final RxList<TeamProject> tpList = RxList();
  RxString selectedTpList = '진행중인 팀플'.obs;

  final TextEditingController nameInputController = TextEditingController();
  final Rx<String> nameInputText = Rx("");

  DateTime? startedAt;
  DateTime? endedAt;

  // meeting_create.dart
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
      WeteamUtils.snackbar('', '팀플 목록을 불러오지 못했어요', icon: SnackbarIcon.fail);
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

  Future<void> finishCreatingOrEditing() async {
    CustomCalendarController ccc = Get.find<CustomCalendarController>();
    if (ccc.selectedDt2.value!.isBefore(ccc.selectedDt1.value!)) {
      startedAt = ccc.selectedDt2.value!;
      endedAt = ccc.selectedDt1.value!;
    } else {
      startedAt = ccc.selectedDt1.value!;
      endedAt = ccc.selectedDt2.value!;
    }

    String title = nameInputText.value.trim();
    int? projectId = selectedTeamProject.value?.id;

    bool success = false;

    if (meeting == null) {
      Meeting? meetingProject = await Get.find<ApiService>().createMeeting(
          title: title,
          startedAt: startedAt!,
          endedAt: endedAt!,
          projectId: projectId);

      success = (meetingProject != null);
      if (success) {
        meeting = meetingProject;
      }
    } else {
      int meetingId = meeting!.id;
      success = await Get.find<ApiService>().editMeeting(
          meetingId: meetingId,
          title: title,
          startedAt: startedAt!,
          endedAt: endedAt!);
    }

    if (success) {
      Get.find<MeetingController>().updateMeetingList();
      Get.to(() => const MeetingCreateFinish());
    } else {
      WeteamUtils.snackbar('', '잠시 오류가 발생했어요', icon: SnackbarIcon.fail);
    }
  }
}
