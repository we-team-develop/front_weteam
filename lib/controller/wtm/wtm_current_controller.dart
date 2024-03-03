import 'dart:collection';

import 'package:get/get.dart';

import '../../model/weteam_user.dart';
import '../../model/wtm_project.dart';
import '../../model/wtm_project_detail.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../util/weteam_utils.dart';
import 'wtm_schedule_controller.dart';

class WTMCurrentController extends GetxController {
  late final Rx<WTMProject> wtm;
  final RxList<WeteamUser> joinedUserList = RxList(); // 시간 선택한 유저
  final RxList<WeteamUser> notJoinedUserList = RxList(); // 시간 선택 안 한 유저

  WTMCurrentController(WTMProject team) {
    wtm = team.obs;
    fetchWTMProjectDetail();
  }

  Future<void> fetchWTMProjectDetail() async {
    ApiService service = Get.find<ApiService>();
    WTMProjectDetail? wtmProjectDetail = await service.getWTMProjectDetail(wtm.value.id);

    // 불러오지 못했을 경우
    if (wtmProjectDetail == null) {
      WeteamUtils.snackbar('불러오지 못함', '오류가 있었습니다');
    } else {
      // 미팅 정보 업데이트(적용)
      wtm.value = wtmProjectDetail.wtmProject;

      // 미팅 스케쥴(시간입력) 관련 데이터 처리 부분 시작
      WTMScheduleController schController = Get.find<WTMScheduleController>();

      int maxPopulation = 0; // 날짜별 최대 참여자 수
      Map<String, int> populationMap = {}; // 날짜별 참여자 수
      Map<String, HashSet<int>> myTimeMap = {}; // 앱 사용자가 선택한 날짜들

      for (WTMUser user in wtmProjectDetail.wtmUserList) {
        bool isMe =
            user.user.id == Get.find<AuthService>().user.value?.id; // 이 유저가 이 앱 실행한 유저인지를 담는 변수

        if (user.timeList.isEmpty) { // 시간 입력 안 한 유저
          notJoinedUserList.add(user.user); // 참여한 유저 목록에 추가
        } else { // 시간 입력 데이터가 있음
          joinedUserList.add(user.user); // 참여 안 한 유저 목록에 추가

          for (MeetingTime time in user.timeList) {
            DateTime startedAt = time.startedAt;
            DateTime endedAt = time.endedAt;

            DateTime parentDt =
            DateTime(startedAt.year, startedAt.month, startedAt.day);
            String strDtKey =
            WeteamUtils.formatDateTime(parentDt, withTime: false);

            int length = endedAt
                .difference(startedAt)
                .inHours;
            for (int i = 0; i <= length; i++) {
              int year = startedAt.year;
              int month = startedAt.month;
              int day = startedAt.day;
              int hour = startedAt.hour + i;

              DateTime dt = DateTime(year, month, day, hour);
              String pMapKey = WeteamUtils.formatDateTime(dt, withTime: true);

              int population = populationMap[pMapKey] ?? 0; // 몇 명이 선택?
              ++population;

              if (maxPopulation < population) {
                maxPopulation = population;
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
    WTMScheduleController schController = Get.find<WTMScheduleController>();
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

    bool success = await Get.find<ApiService>().setWtmSchedule(wtm.value.id, timeList);
    return success;
  }
}

class MeetingTime{
  final int? id;
  final DateTime startedAt;
  final DateTime endedAt;

  MeetingTime(this.startedAt, this.endedAt, {this.id});

  factory MeetingTime.fromJson(Map map) {
    return MeetingTime(
        DateTime.parse(map['startedAt']),
        DateTime.parse(map['endedAt']),
        id: map['id']);
  }

  Map<String, String> toMap() {
    return {
      'startedAt': WeteamUtils.formatDateTime(startedAt, withTime: true),
      'endedAt': WeteamUtils.formatDateTime(endedAt, withTime: true),
    };
  }
}
