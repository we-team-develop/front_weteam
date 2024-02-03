

import 'weteam_user.dart';

class TeamProject {
  int id;
  String img;
  String title;
  String description;
  int memberSize;
  DateTime startedAt;
  DateTime endedAt;
  bool done;
  WeteamUser host;

  TeamProject(
      {this.id = -1,
      this.img = "",
      this.title = "",
      this.description = "",
      this.memberSize = -1, // 입력 안 된 경우를 구분할 수 있어야 함
      required this.startedAt,
      required this.endedAt,
      this.done = false,
      required this.host}) {
    done = endedAt.difference(DateTime.now()).inSeconds.isNegative;
  }

  factory TeamProject.fromJson(Map data) {
    return TeamProject(
        id: data['id'],
        title: data['name'],
        description: data['explanation'],
        startedAt: DateTime.parse(data['startedAt']),
        endedAt: DateTime.parse(data['endedAt']),
        memberSize: data['headCount'],
        done: data['done'],
        host: WeteamUser.fromJson(data['host'] ?? {}));
  }
}
