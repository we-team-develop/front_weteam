import 'team_project.dart';

class WTMProject {
  final int id;
  final String title;
  final DateTime startedAt;
  final DateTime endedAt;
  final TeamProject? project;

  const WTMProject({
    required this.id,
    required this.title,
    required this.startedAt,
    required this.endedAt,
    required this.project
  });

  factory WTMProject.fromJson(Map data) {
    return WTMProject(
        id: data['id'],
        title: data['title'],
        startedAt: DateTime.parse(data['startedAt']),
        endedAt: DateTime.parse(data['endedAt']),
        project: data['project'] != null ? TeamProject.fromJson(data['project']) : null);
  }

  @override
  bool operator ==(Object other) {
    if (other is! WTMProject) return false;
    if (other.hashCode == hashCode) return true;
    return id == other.id &&
        title == other.title &&
        startedAt.isAtSameMomentAs(other.startedAt) &&
        endedAt.isAtSameMomentAs(other.endedAt) &&
        project == other.project;
  }
}
