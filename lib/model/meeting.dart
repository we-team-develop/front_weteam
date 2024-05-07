import 'package:get/get.dart';

import '../service/team_project_service.dart';
import 'team_project.dart';

class Meeting {
  final int id;
  final String title;
  final String hashedId;
  final DateTime startedAt;
  final DateTime endedAt;
  final RxTeamProject? rxProject;

  const Meeting(
      {required this.id,
      required this.title,
      required this.startedAt,
      required this.endedAt,
      required this.hashedId,
      required this.rxProject});

  factory Meeting.fromJson(Map data) {
    TeamProjectService tps = Get.find<TeamProjectService>();

    return Meeting(
        id: data['id'],
        title: data['title'],
        hashedId: data['hashedId'] ?? "",
        startedAt: DateTime.parse(data['startedAt']),
        endedAt: DateTime.parse(data['endedAt']),
        rxProject: data['project'] != null
            ? tps.getTeamProjectById(TeamProject.fromJsonAndUpdate(data['project']).id)!
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
        rxProject == other.rxProject;
  }

  @override
  int get hashCode => Object.hash(id, title, startedAt, endedAt, rxProject);
}
