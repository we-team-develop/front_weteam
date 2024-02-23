import 'package:get/get.dart';

import '../../model/wtm_project.dart';
import '../../service/api_service.dart';
import '../../util/weteam_utils.dart';
import 'wtm_schedule_controller.dart';

class WTMCurrentController extends GetxController {
  late final Rx<WTMProject> wtm;

  WTMCurrentController(WTMProject team) {
    wtm = team.obs;
    fetchWTMProject();
  }

  Future<void> fetchWTMProject() async {
    ApiService service = Get.find<ApiService>();
    WTMProject? wtm = await service.getWTMProject(this.wtm.value.id);
    if (wtm != null) {
      this.wtm.value = wtm;
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
          MeetingTime t = MeetingTime(DateTime(key.year, key.month, key.day, startHour),
              DateTime(key.year, key.month, key.day, endHour));
          timeList.add(t);
        } else if ((nextElement - element) > 1) {
          // 하나의 객체 생성
          MeetingTime t = MeetingTime(DateTime(key.year, key.month, key.day, startHour),
              DateTime(key.year, key.month, key.day, endHour));
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
  final DateTime startedAt;
  final DateTime endedAt;

  MeetingTime(this.startedAt, this.endedAt);

  Map<String, String> toMap() {
    return {
      'startedAt': WeteamUtils.formatDateTime(startedAt, withTime: true),
      'endedAt': WeteamUtils.formatDateTime(endedAt, withTime: true),
    };
  }
}
