import 'team_project.dart';

class WTMProject {
  final int id;
  final String title;
  final String img;
  final DateTime startedAt;
  final DateTime endedAt;
  final TeamProject project;

  const WTMProject({
    required this.id,
    required this.img,
    required this.title,
    required this.startedAt,
    required this.endedAt,
    required this.project
  });

  factory WTMProject.fromJson(Map data) {
    return WTMProject(
        img: "",
        id: data['id'],
        title: data['title'],
        startedAt: DateTime.parse(data['startedAt']),
        endedAt: DateTime.parse(data['endedAt']),
        project: TeamProject.fromJson(data['project'] ?? {}));
  }

  @override
  bool operator ==(Object other) {
    if (other is! WTMProject) return false;
    if (other.hashCode == hashCode) return true;
    return id == other.id &&
        img == other.img &&
        title == other.title &&
        startedAt.isAtSameMomentAs(other.startedAt) &&
        endedAt.isAtSameMomentAs(other.endedAt) &&
        project == other.project;
  }
}
