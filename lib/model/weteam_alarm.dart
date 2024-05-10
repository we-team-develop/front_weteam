
import 'package:flutter/widgets.dart';

import '../service/team_project_service.dart';
import 'team_project.dart';
import 'weteam_user.dart';

class WeteamAlarm {
  final int id;
  final String status;
  final String date;
  bool read;

  final WeteamUser? user;
  final WeteamUser? targetUser;
  final RxTeamProject? rxProject;

  WeteamAlarm(
      {required this.id,
      required this.status,
      required this.date,
      required this.read,
      this.user,
      this.targetUser,
      this.rxProject});

  factory WeteamAlarm.fromJson(Map data) {
    return WeteamAlarm(
      id: data['id'],
      status: data['status'],
      date: data['date'],
      read: data['read'],
      user: data['user'] != null ? WeteamUser.fromJson(data['user']) : null,
      targetUser: data['targetUser'] != null ? WeteamUser.fromJson(data['targetUser']) : null,
      rxProject: data['project'] != null
          ? RxTeamProject.updateOrCreate(TeamProject.fromJson(data['project']))
          : null,
    );
  }

  String getTitle() {
    TeamProject tp = rxProject!.value;
    if (status == "JOIN") {
      return "[${tp.title}]에 ${targetUser?.username}님이 참가했습니다!";
    } else if (status == "EXIT") {
      return "[${tp.title}]에 ${targetUser?.username}님이 퇴장했습니다.";
    } else if (status == "CHANGE_HOST") {
      return "[${tp.title}]의 호스트가 ${targetUser?.username}님으로 변경되었습니다.";
    } else if (status == "UPDATE_PROJECT") {
      return "[${tp.title}]의 정보가 변경되었습니다!";
    } else if (status == "KICK") {
      return "[${tp.title}]의 ${targetUser?.username}님이 퇴출되었어요.";
    } else if (status == "DONE") {
      return "[${tp.title}]의 진행 상태가 변경되었어요.";
    } else if (status == "NEW_MEETING") {
      return '[${tp.title}]에서 새로운 언제보까가 생성되었습니다!';
    } else {
      debugPrint("알 수 없는 알림 타입 : $status");
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
    } else if (status == "NEW_MEETING") {
      return '우리 언제 만날까...?';
    } else {
      debugPrint("알 수 없는 알림 타입 : $status");
    }

    return "";
  }
}
