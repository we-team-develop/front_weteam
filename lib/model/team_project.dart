import 'weteam_user.dart';

class TeamProject {
  String hashedId;
  int id;
  int imageId;
  String title;
  String description;
  int memberSize;
  DateTime startedAt;
  DateTime endedAt;
  bool done;
  WeteamUser host;

  TeamProject(
      {this.hashedId = "",
      this.id = -1,
      this.imageId = 0,
      this.title = "",
      this.description = "",
      this.memberSize = -1, // 입력 안 된 경우를 구분할 수 있어야 함
      required this.startedAt,
      required this.endedAt,
      this.done = false,
      required this.host});

  factory TeamProject.fromJson(Map data) {
    return TeamProject(
        hashedId: data['hashedId'] ?? "",
        id: data['id'],
        title: data['name'],
        imageId: data['imageId'],
        description: data['explanation'],
        startedAt: DateTime.parse(data['startedAt']),
        endedAt: DateTime.parse(data['endedAt']),
        memberSize: data['headCount'],
        done: data['done'],
        host: WeteamUser.fromJson(data['host'] ?? {}));
  }

  @override
  bool operator ==(Object other) {
    if (other is! TeamProject) return false;
    if (other.hashCode == hashCode) return true;
    return id == other.id &&
        imageId == other.imageId &&
        title == other.title &&
        description == other.description &&
        memberSize == other.memberSize &&
        startedAt.isAtSameMomentAs(other.startedAt) &&
        endedAt.isAtSameMomentAs(other.endedAt) &&
        done == other.done &&
        host == other.host;
  }
}
