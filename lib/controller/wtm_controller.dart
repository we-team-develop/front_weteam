import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front_weteam/controller/home_controller.dart';
import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/model/weteam_user.dart';
import 'package:front_weteam/model/wtm_project.dart';
import 'package:front_weteam/service/api_service.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:front_weteam/service/overlay_service.dart';
import 'package:front_weteam/view/widget/overlay_widget.dart';
import 'package:get/get.dart';
import '../util/weteam_utils.dart';

class WTMController extends GetxController {
  final Rx<OverlayEntry?> _overlayEntry = Rx<OverlayEntry?>(null);
  final Rx<String> searchText = Rx("");
  String? searchWait;

  final ScrollController wtmScrollController = ScrollController();

  final TextEditingController nameInputController = TextEditingController();
  final Rx<String> nameInputText = Rx("");

  final Rxn<List<WTMProject>> wtmList = Rxn<List<WTMProject>>();
  final Rxn<TeamProject> selectedTeamProject = Rxn();
  final RxList<TeamProject> tpList = RxList();
  RxString selectedTpList = '진행중인 팀플'.obs;

  WTMController() {
    updateWTMProjectList();
  }

  // 웬투밋 관련 페이지가 모두 닫혔을 때 호출됩니다.
  @override
  void onClose() {
    super.onClose();
    _removeOverlay(); // 튜토리얼 오버레이를 닫습니다.
  }

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

  // WTM MAIN
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

  // 오버레이
  RxBool shouldShowOverlay = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    loadPreference();
    print('check');
  }

// 사용자의 선호를 반영하여 showOverlay 값을 설정합니다.
  void loadPreference() {
    bool shouldShow = OverlayService.shouldShowOverlay();
    shouldShowOverlay.value = shouldShow;
    print('Load showOverlay Preference: ${shouldShowOverlay.value}');
  }

  void toggleShouldShowOverlay() async {
    shouldShowOverlay.value = !shouldShowOverlay.value;
    await OverlayService.setShouldShowOvelay(shouldShowOverlay.value);
    print('Saved showOverlay: ${shouldShowOverlay.value} to SharedPreferences');
  }

  void showOverlay(BuildContext context) async {
    if (_overlayEntry.value != null || shouldShowOverlay.isFalse) {
      print('Overlay not shown due to conditions.');
      // 이미 오버레이가 표시되어 있거나 사용자가 "다시 보지 않기"를 선택한 경우 무시합니다.
      return;
    }
    print(
        'Attempting to show overlay. showOverlay: ${shouldShowOverlay.value}'); // 로그 출력

    TutorialOverlay();

    Overlay.of(context).insert(_overlayEntry.value!);
  }

  void _removeOverlay() {
    _overlayEntry.value?.remove();
    _overlayEntry.value = null;
  }

  // wtm list 관련
  Future<void> updateWTMProjectList() async {
    GetWTMProjectListResult? result =
        await Get.find<ApiService>().getWTMProjectList(0, 'DESC', 'STARTED_AT');
    if (result != null) {
      wtmList.value = result.wtmprojectList;
    } else {
      wtmList.value = [
        WTMProject(
            id: 1,
            img: "",
            title: 'title',
            startedAt: DateTime.now(),
            endedAt: DateTime.now(),
            project: Get.find<HomeController>().oldTpList[0])
      ];
    }
  }
}
