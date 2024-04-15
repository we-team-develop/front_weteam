import 'weteam_user.dart';

class TeamProject {
  /// 팀플 초대용 id
  String hashedId;
  /// 팀플 id
  int id;
  /// 팀플 이미지 id
  int imageId;
  /// 팀플 이름
  String title;
  /// 팀플 설명
  String description;
  /// 팀플 멤버 수
  int memberSize;
  /// 팀플 시작일
  DateTime startedAt;
  /// 팀플 종료일
  DateTime endedAt;
  /// 팀플 완료 여부
  bool done;
  /// 팀플 호스트 유저
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
        imageId: data['imageId'] ?? 0, //null 예외 생김 수정
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
