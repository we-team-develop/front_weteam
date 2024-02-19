import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/wtm_project.dart';
import '../../service/api_service.dart';
import '../../service/overlay_service.dart';
import '../../view/widget/overlay_widget.dart';
import '../mainpage/home_controller.dart';

class WTMController extends GetxController {
  final Rx<OverlayEntry?> _overlayEntry = Rx<OverlayEntry?>(null);

  final ScrollController wtmScrollController = ScrollController();

  final Rxn<List<WTMProject>> wtmList = Rxn<List<WTMProject>>();

  WTMController() {
    updateWTMProjectList();
  }

  // 웬투밋 관련 페이지가 모두 닫혔을 때 호출됩니다.
  @override
  void onClose() {
    super.onClose();
    _removeOverlay(); // 튜토리얼 오버레이를 닫습니다.
  }

  // WTM MAIN
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
