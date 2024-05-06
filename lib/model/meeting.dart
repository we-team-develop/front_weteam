import 'team_project.dart';

class Meeting {
  final int id;
  final String title;
  final String hashedId;
  final DateTime startedAt;
  final DateTime endedAt;
  final TeamProject? project;

  const Meeting(
      {required this.id,
      required this.title,
      required this.startedAt,
      required this.endedAt,
      required this.hashedId,
      required this.project});

  factory Meeting.fromJson(Map data) {
    return Meeting(
        id: data['id'],
        title: data['title'],
        hashedId: data['hashedId'] ?? "",
        startedAt: DateTime.parse(data['startedAt']),
        endedAt: DateTime.parse(data['endedAt']),
        project: data['project'] != null
            ? TeamProject.fromJson(data['project'])
            : null);
  }

  @override
  bool operator ==(Object other) {
    if (other.hashCode == hashCode) return true;
    return other is Meeting &&
        id == other.id &&
        title == other.title &&
        startedAt.isAtSameMomentAs(other.startedAt) &&
        endedAt.isAtSameMomentAs(other.endedAt) &&
        project == other.project;
  }

  @override
  int get hashCode => Object.hash(id, title, startedAt, endedAt, project);
}
