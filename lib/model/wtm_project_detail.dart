import '../controller/wtm/wtm_current_controller.dart';
import 'weteam_user.dart';
import 'wtm_project.dart';

class WTMProjectDetail {
  final WTMProject wtmProject;
  final List<WTMUser> wtmUserList;

  const WTMProjectDetail({required this.wtmProject, required this.wtmUserList});

  factory WTMProjectDetail.fromJson(Map map) {
    List meetingUserList = map['meetingUserList'];
    return WTMProjectDetail(wtmProject: WTMProject.fromJson(map),
        wtmUserList: List<WTMUser>.generate(
            meetingUserList.length,
            (index) => WTMUser.fromJson(meetingUserList[index])));
  }
}

class WTMUser {
  final int id;
  final WeteamUser user;
  final List<MeetingTime> timeList;

  const WTMUser({required this.id, required this.user, required this.timeList});

  factory WTMUser.fromJson(Map map) {
    List timeSlotList = map['timeSlotList'];
    return WTMUser(id: map['id'],
        user: WeteamUser.fromJson(map['user']),
        timeList: List<MeetingTime>.generate(
            timeSlotList.length, (index) => MeetingTime.fromJson(timeSlotList[index])));
  }
}