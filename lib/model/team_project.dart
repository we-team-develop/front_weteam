import 'package:front_weteam/model/weteam_user.dart';

class TeamProject {
  final int id;
  final String img;
  final String title;
  final String description;
  final int memberSize;
  final String date;
  final bool done;
  final WeteamUser host;

  const TeamProject(
      {this.id = -1,
      this.img = "",
      this.title = "",
      this.description = "",
      this.memberSize = -1, // 입력 안 된 경우를 구분할 수 있어야 함
      this.date = "",
        this.done = false,
      required this.host});

  factory TeamProject.fromJson(Map data) {
    return TeamProject(
        id: data['id'],
        title: data['name'],
        description: data['explanation'],
        date: "${data['startedAt']} ~ ${data['endedAt']}",
        memberSize: data['headCount'],
        done: data['done'],
        host: WeteamUser.fromJson(data['host'] ?? {}));
  }
}
