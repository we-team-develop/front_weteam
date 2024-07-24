import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/meeting.dart';
import '../../model/team_project.dart';
import '../../service/api_service.dart';
import '../../service/team_project_service.dart';
import '../../util/weteam_utils.dart';
import '../../view/meeting/create/meeting_create_finish.dart';
import '../custom_calendar_controller.dart';
import 'meeting_controller.dart';

class MeetingCreateController extends GetxController {
  Meeting? meeting;

  final Rx<String> searchText = Rx("");
  String? searchWait;

  final Rxn<TeamProject> selectedTeamProject = Rxn();
  RxBool showingDoneList = RxBool(false);
  late Rx<RxTeamProjectList> tpList;

  final TextEditingController nameInputController = TextEditingController();
  final Rx<String> nameInputText = Rx("");

  DateTime? startedAt;
  DateTime? endedAt;

  @override
  void onInit() {
    super.onInit();
    TeamProjectService tpService = Get.find<TeamProjectService>();
    tpList = Rx(tpService.notDoneList);
  }

  // meeting_create.dart
  void setSelectedTpList(bool showDoneList) {
    showingDoneList.value = showDoneList;

    TeamProjectService tpService = Get.find<TeamProjectService>();
    if (showDoneList) {
      tpList.value = tpService.doneList;
    } else {
      tpList.value = tpService.notDoneList;
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
