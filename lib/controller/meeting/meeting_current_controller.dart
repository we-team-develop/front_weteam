import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../model/weteam_user.dart';
import '../../model/meeting.dart';
import '../../model/meeting_detail.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../util/weteam_utils.dart';
import '../../view/widget/meeting_info_overlay_widget.dart';
import 'meeting_schedule_controller.dart';

class CurrentMeetingController extends GetxController {
  late final Rx<Meeting> meeting;
  final RxList<WeteamUser> joinedUserList = RxList(); // 시간 선택한 유저
  final RxList<WeteamUser> notJoinedUserList = RxList(); // 시간 선택 안 한 유저

  CurrentMeetingController(Meeting team) {
    Get.put(MeetingScheduleController());
    meeting = team.obs;
    fetchMeetingDetail();
  }

  //오버레이 관련
  OverlayEntry? _overlayEntry;

  void showOverlay(BuildContext context) {
    if (_overlayEntry != null) return; // 이미 오버레이가 있는지 확인

    _overlayEntry = OverlayEntry(
      builder: (context) => MeetingInfoOverlay(
        onConfirm: removeOverlay, // 확인 버튼을 눌렀을 때 오버레이를 지우는 콜백
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // 합산된 유저 수 계산
  int getTotalUserCount() {
    return joinedUserList.length + notJoinedUserList.length;
  }

  // 이미지 경로를 반환하는 메서드 추가
  String getImagePathForUserCount() {
    int totalUserCount = getTotalUserCount();
    // 최대 10명
    int validUserCount = totalUserCount.clamp(1, 10);
    return 'assets/images/meeting$validUserCount.png'; // 경로는 실제 경로에 맞게 조정 필요
  }

  double getImageHeightForUserCount() {
    int totalUserCount = getTotalUserCount();
    return (totalUserCount <= 5) ? 15.82.h : 42.82.h;
  }

  //
  Future<void> fetchMeetingDetail() async {
    ApiService service = Get.find<ApiService>();
    notJoinedUserList.clear();
    joinedUserList.clear();
    MeetingDetail? meetingDetail =
        await service.getMeetingDetail(meeting.value.id);

    // 불러오지 못했을 경우
    if (meetingDetail == null) {
      WeteamUtils.snackbar('', '오류가 발생하여 불러오지 못했어요');
    } else {
      // 미팅 정보 업데이트(적용)
      meeting.value = meetingDetail.meetingProject;

      // 미팅 스케쥴(시간입력) 관련 데이터 처리 부분 시작
      MeetingScheduleController schController =
          Get.find<MeetingScheduleController>();

      int maxPopulation = 0; // 날짜별 최대 참여자 수
      Map<String, List<MeetingUser>> populationMap = {}; // 날짜별 참여자 목록
      Map<String, HashSet<int>> myTimeMap = {}; // 앱 사용자가 선택한 날짜들

      for (MeetingUser user in meetingDetail.meetingUserList) {
        bool isMe = user.user.id ==
            Get.find<AuthService>().user.value?.id; // 이 유저가 이 앱 실행한 유저인지를 담는 변수

        if (user.timeList.isEmpty) {
          // 시간 입력 안 한 유저
          notJoinedUserList.add(user.user); // 참여한 유저 목록에 추가
        } else {
          // 시간 입력 데이터가 있음
          joinedUserList.add(user.user); // 참여 안 한 유저 목록에 추가

          for (MeetingTime time in user.timeList) {
            DateTime startedAt = time.startedAt;
            DateTime endedAt = time.endedAt;

            DateTime parentDt =
                DateTime(startedAt.year, startedAt.month, startedAt.day);
            String strDtKey =
                WeteamUtils.formatDateTime(parentDt, withTime: false);

            int length = endedAt.difference(startedAt).inHours;
            for (int i = 0; i <= length; i++) {
              int year = startedAt.year;
              int month = startedAt.month;
              int day = startedAt.day;
              int hour = startedAt.hour + i;

              DateTime dt = DateTime(year, month, day, hour);
              String pMapKey = WeteamUtils.formatDateTime(dt, withTime: true);

              List<MeetingUser> population =
                  populationMap[pMapKey] ?? []; // 누구누구가 선택?
              population.add(user); // 선택한 유저 목록에 추가

              if (maxPopulation < population.length) {
                maxPopulation = population.length;
              }

              populationMap[pMapKey] = population;

              if (isMe) {
                HashSet<int> set = myTimeMap[strDtKey] ?? HashSet();
                set.add(hour);
                myTimeMap[strDtKey] = set;
              }
            }
          }
        }
      }

      schController.maxPopulation.value = maxPopulation;
      schController.populationMap.value = populationMap;
      schController.selected.value = myTimeMap;
    }
  }

  Future<bool> setSelectedTimes() async {
    MeetingScheduleController schController =
        Get.find<MeetingScheduleController>();
    List<MeetingTime> timeList = [];

    schController.selected.forEach((key, value) {
      List<int> hourList = value.toList();
      hourList.sort();

      int? startHour;
      int? endHour;
      for (int i = 0; i < hourList.length; i++) {
        int element = hourList[i];
        int? nextElement;
        if (i + 1 < hourList.length) {
          nextElement = hourList[i + 1];
        }

        startHour ??= element;
        endHour = element;

        if (nextElement == null) {
          MeetingTime t = MeetingTime(
              DateTime.parse(key).copyWith(hour: startHour),
              DateTime.parse(key).copyWith(hour: endHour));
          timeList.add(t);
        } else if ((nextElement - element) > 1) {
          // 하나의 객체 생성
          MeetingTime t = MeetingTime(
              DateTime.parse(key).copyWith(hour: startHour),
              DateTime.parse(key).copyWith(hour: endHour));
          timeList.add(t);

          // 초기화
          startHour = null;
          endHour = null;
        }
      }
    });

    bool success = await Get.find<ApiService>()
        .setMeetingSchedule(meeting.value.id, timeList);
    return success;
  }
}

class MeetingTime {
  final int? id;
  final DateTime startedAt;
  final DateTime endedAt;

  MeetingTime(this.startedAt, this.endedAt, {this.id});

  factory MeetingTime.fromJson(Map map) {
    return MeetingTime(
        DateTime.parse(map['startedAt']), DateTime.parse(map['endedAt']),
        id: map['id']);
  }

  Map<String, String> toMap() {
    return {
      'startedAt': WeteamUtils.formatDateTime(startedAt, withTime: true),
      'endedAt': WeteamUtils.formatDateTime(endedAt, withTime: true),
    };
  }
}
