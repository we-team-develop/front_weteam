import 'dart:collection';

import 'package:get/get.dart';

import '../../model/wtm_project.dart';
import '../../model/wtm_project_detail.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../util/weteam_utils.dart';
import 'wtm_schedule_controller.dart';

class WTMCurrentController extends GetxController {
  late final Rx<WTMProject> wtm;

  WTMCurrentController(WTMProject team) {
    wtm = team.obs;
    fetchWTMProjectDetail();
  }

  Future<void> fetchWTMProjectDetail() async {
    ApiService service = Get.find<ApiService>();
    WTMProjectDetail? wtmPD = await service.getWTMProjectDetail(wtm.value.id);

    if (wtmPD == null) {
      WeteamUtils.snackbar('불러오지 못함', '오류가 있었습니다');
    } else {
      wtm.value = wtmPD.wtmProject;
      WTMScheduleController schController = Get.find<WTMScheduleController>();

      int maxPopulation = 0;
      Map<String, int> populationMap = {};
      Map<String, HashSet<int>> currentUserTimeMap = {};

      for (WTMUser user in wtmPD.wtmUserList) {
        bool isCurrentUser =
            user.user.id == Get.find<AuthService>().user.value?.id;

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

            DateTime dt = DateTime(year , month, day, hour);
            String pMapKey = WeteamUtils.formatDateTime(dt, withTime: true);

            int population = populationMap[pMapKey] ?? 0; // 몇 명이 선택?
            ++population;

            if (maxPopulation < population) {
              maxPopulation = population;
            }

            populationMap[pMapKey] = population;

            if (isCurrentUser) {
              HashSet<int> set = currentUserTimeMap[strDtKey] ?? HashSet();
              set.add(hour);
              currentUserTimeMap[strDtKey] = set;
            }
          }
        }
      }

      schController.maxPopulation.value = maxPopulation;
      schController.populationMap.value = populationMap;
      schController.selected.value = currentUserTimeMap;
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
