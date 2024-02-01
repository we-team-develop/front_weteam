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
      date: "2023.01.01", // TODO: 서버에서 받아오기
      read: data['read'],
      user: data['user'] != null ? WeteamUser.fromJson(data['user']) : null,
      project:
          data['project'] != null ? TeamProject.fromJson(data['project']) : null,
    );
  }

  String getTitle() {
    if (status == "JOIN") {
      return "[${project?.title}]에 ${user?.username}님이 참가했습니다!";
    }

    return "";
  }

  String getContent() {
    if (status == "JOIN") {
      return "모두 새로운 멤버를 환영해주세요!👋";
    }

    return "";
  }
}
