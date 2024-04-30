import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/meeting.dart';
import '../../service/api_service.dart';
import '../../service/meeting_overlay_service.dart';
import '../../view/widget/tutorial_overlay_widget.dart';
import '../mainpage/home_controller.dart';

class MeetingController extends GetxController {
  final Rx<OverlayEntry?> _overlayEntry = Rx<OverlayEntry?>(null);
  final PageController overlayPageController = PageController();

  final ScrollController meetingScrollController = ScrollController();

  final Rxn<List<Meeting>> meetingList = Rxn<List<Meeting>>();

  MeetingController() {
    updateMeetingList();
  }

  // 미팅 관련 페이지가 모두 닫혔을 때 호출됩니다.
  @override
  void onClose() {
    super.onClose();
    removeOverlay(); // 튜토리얼 오버레이를 닫습니다.
  }

  // Meeting MAIN
  // 오버레이
  RxBool shouldShowOverlay = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    loadPreference();
    debugPrint('check');
  }

// 사용자의 선호를 반영하여 showOverlay 값을 설정합니다.
  void loadPreference() {
    bool shouldShow = MeetingOverlayService.shouldShowOverlay();
    shouldShowOverlay.value = shouldShow;
    debugPrint('Load showOverlay Preference: ${shouldShowOverlay.value}');
  }

  void toggleShouldShowOverlay() async {
    shouldShowOverlay.value = !shouldShowOverlay.value;
    await MeetingOverlayService.setShouldShowOverlay(shouldShowOverlay.value);
    debugPrint('Saved showOverlay: ${shouldShowOverlay.value} to SharedPreferences');
  }

  void showOverlay(BuildContext context) async {
    if (_overlayEntry.value != null || shouldShowOverlay.isFalse) {
      debugPrint('Overlay not shown due to conditions.');
      // 이미 오버레이가 표시되어 있거나 사용자가 "다시 보지 않기"를 선택한 경우 무시합니다.
      return;
    }
    debugPrint(
        'Attempting to show overlay. showOverlay: ${shouldShowOverlay.value}'); // 로그 출력

    _overlayEntry.value = OverlayEntry(
      builder: (context) => const TutorialOverlay(),
    );
    Overlay.of(context).insert(_overlayEntry.value!);
  }

  void removeOverlay() {
    _overlayEntry.value?.remove();
    _overlayEntry.value = null;
  }

  // Meeting list 관련
  Future<void> updateMeetingList() async {
    GetMeetingListResult? result =
        await Get.find<ApiService>().getMeetingList(0, 'DESC', 'STARTED_AT');
    if (result != null) {
      meetingList.value = result.meetingList;
    } else {
      meetingList.value = [
        Meeting(
            id: 1,
            title: 'title',
            startedAt: DateTime.now(),
            endedAt: DateTime.now(),
            project: Get.find<HomeController>().oldTpList[0])
      ];
    }
  }
}
