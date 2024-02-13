import 'package:front_weteam/model/team_project.dart';

class WTMProject {
  int id;
  String title;
  String img;
  DateTime startedAt;
  DateTime endedAt;
  bool done;
  TeamProject project;

  WTMProject({
    this.id = -1,
    this.img = "",
    this.title = "",
    required this.startedAt,
    required this.endedAt,
    required this.project,
    this.done = false,
  }) {
    done = endedAt.difference(DateTime.now()).inSeconds.isNegative;
  }

  factory WTMProject.fromJson(Map data) {
    return WTMProject(
        id: data['id'],
        title: data['name'],
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
        done == other.done &&
        project == other.project;
  }
}
