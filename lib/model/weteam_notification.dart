import 'team_project.dart';
import 'weteam_user.dart';

class WeteamNotification {
  final int id;
  final String status;
  final String date;
  final bool read;

  final WeteamUser? user;
  final TeamProject? project;

  const WeteamNotification(
      {required this.id,
      required this.status,
      required this.date,
      required this.read,
      this.user,
      this.project});

  factory WeteamNotification.fromJson(Map data) {
    return WeteamNotification(
      id: data['id'],
      status: data['status'],
      date: data['date'],
      read: data['read'],
      user: data['user'] != null ? WeteamUser.fromJson(data['user']) : null,
      project:
          data['project'] != null ? TeamProject.fromJson(data['project']) : null,
    );
  }

  String getTitle() {
    if (status == "JOIN") {
      return "[${project?.title}]에 ${user?.username}님이 참가했습니다!";
    } else if (status == "EXIT") {
      return "[${project?.title}]에 ${user?.username}님이 퇴장했습니다.";
    } else if (status == "CHANGE_HOST") {
      return "[${project?.title}]의 호스트가 ${user?.username}님으로 변경되었습니다.";
    } else if (status == "UPDATE_PROJECT") {
      return "[${project?.title}]의 정보가 변경되었습니다! 확인해주세요!";
    } else if (status == "KICK") {
      return "[${project?.title}]의 ${user?.username}님이 퇴출되었어요.";
    } else if (status == "DONE") {
      return "[${project?.title}]의 진행 상태가 변경되었어요.";
    }


    return "";
  }

  String getContent() {
    if (status == "JOIN") {
      return "모두 새로운 멤버를 환영해주세요!👋";
    } else if (status == "EXIT") {
      return '이 멤버와는 더 이상 함께하실수 없습니다...😢';
    } else if (status == "CHANGE_HOST") {
      return '새로운 호스트를 격하게 응원해주세요💃';
    } else if (status == "UPDATE_PROJECT") {
      return '새로운 마음으로 다시 시작하는 팀플❤️';
    } else if (status == "KICK") {
      return '안녕히가세요😢';
    } else if (status == "DONE") {
      return '진행 상태가 바뀌었어요❗';
    }

    return "";
  }
}
