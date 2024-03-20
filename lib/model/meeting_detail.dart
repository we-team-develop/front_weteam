import '../controller/meeting/meeting_current_controller.dart';
import 'weteam_user.dart';
import 'meeting.dart';

class MeetingDetail {
  final Meeting meetingProject;
  final List<MeetingUser> meetingUserList;

  const MeetingDetail({required this.meetingProject, required this.meetingUserList});

  factory MeetingDetail.fromJson(Map map) {
    List meetingUserList = map['meetingUserList'];
    return MeetingDetail(meetingProject: Meeting.fromJson(map),
        meetingUserList: List<MeetingUser>.generate(
            meetingUserList.length,
            (index) => MeetingUser.fromJson(meetingUserList[index])));
  }
}

class MeetingUser {
  final int id;
  final WeteamUser user;
  final List<MeetingTime> timeList;

  const MeetingUser({required this.id, required this.user, required this.timeList});

  factory MeetingUser.fromJson(Map map) {
    List timeSlotList = map['timeSlotList'];
    return MeetingUser(id: map['id'],
        user: WeteamUser.fromJson(map['user']),
        timeList: List<MeetingTime>.generate(
            timeSlotList.length, (index) => MeetingTime.fromJson(timeSlotList[index])));
  }
}