import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/team_project.dart';
import '../model/weteam_notification.dart';
import '../model/weteam_project_user.dart';
import '../model/weteam_user.dart';
import '../util/custom_get_connect.dart';

class ApiService extends CustomGetConnect implements GetxService {
  final String _baseUrl = "http://15.164.221.170:9090"; // baseUrl 주소

  @override
  void onInit() {
    super.onInit();

    httpClient
      ..baseUrl = _baseUrl
      ..timeout = const Duration(seconds: 15);
  }

  Future<WeteamUser?> getCurrentUser() async {
    Response rp = await get('/api/users');
    if (rp.statusCode != 200) {
      debugPrint(
          "statusCode가 200이 아님 (${rp.statusCode} ,,, ${rp.request!.url.toString()} ${rp.bodyString}");
      return null;
    }

    String? json = rp.bodyString;
    debugPrint('$json');
    if (json == null) {
      debugPrint("bodyString is null");
      return null;
    }

    sharedPreferences.setString(SharedPreferencesKeys.weteamUserJson, json);

    return WeteamUser.fromJson(jsonDecode(json));
  }

  Future<bool> withdrawal() async {
    Response rp = await delete('/api/users');
    if (rp.statusCode == 204) {
      // 탈퇴 성공시 204
      return true;
    } else {
      debugPrint(rp.bodyString);
      return false;
    }
  }

  // 프로필 없으면 (회원가입 x) -1 반환
  Future<int?> getMyProfiles() async {
    Response rp = await get('/api/profiles'); // 회원가입 미완료시 404

    String? body = rp.bodyString!;
    Map responseData = jsonDecode(body);

    int? statusCode = responseData['statusCode'] ?? rp.statusCode;
    if (statusCode == 200 || statusCode == 404 || statusCode == 500) {
      if (statusCode == 404) {
        return -1;
      }
      if (statusCode == 500) {
        if (responseData['message'] != null) {
          if (responseData['message'].contains('조회할')) return -1;
        } else {
          return null;
        }
      }

      return responseData['imageIdx'];
    } else {
      debugPrint("프로필 사진 ID를 가져오지 못함 : 서버가 $statusCode으로 응답함");
      return null;
    }
  }

  Future<bool> createUserProfiles(int imageIdx) async {
    Response rp = await post('/api/profiles/$imageIdx', {});
    if (rp.statusCode != 201) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> changeUserProfiles(int imageIdx) async {
    Response rp = await patch('/api/profiles/$imageIdx', {});
    debugPrint("${rp.statusCode}");
    if (rp.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> createTeamProject(String name, DateTime startedAt,
      DateTime endedAt, String explanation) async {
    Map data = {
      'name': name,
      'startedAt':
      "${startedAt.year}-${startedAt.month.toString().padLeft(2, '0')}-${startedAt.day.toString().padLeft(2, '0')}",
      'endedAt':
      "${endedAt.year}-${endedAt.month.toString().padLeft(2, '0')}-${endedAt.day.toString().padLeft(2, '0')}",
      'explanation': explanation
    };
    debugPrint("$data");
    Response rp = await post('/api/projects', data);
    debugPrint(rp.bodyString);
    return rp.statusCode == 201;
  }

  Future<bool> editTeamProject(TeamProject tp) async {
    Map data = {
      'name': tp.title,
      'startedAt':
      "${tp.startedAt.year}-${tp.startedAt.month.toString().padLeft(2, '0')}-${tp.startedAt.day.toString().padLeft(2, '0')}",
      'endedAt':
      "${tp.endedAt.year}-${tp.endedAt.month.toString().padLeft(2, '0')}-${tp.endedAt.day.toString().padLeft(2, '0')}",
      'explanation': tp.description
    };
    Response rp = await patch('/api/projects/${tp.id}', data);
    return rp.statusCode == 204;
  }

  Future<GetTeamProjectListResult?> getTeamProjectList(
      int page, bool done, String direction, String field, int userId,
      {String? cacheKey}) async {
    Response rp = await get('/api/projects', query: {
      'page': page.toString(),
      'size': 10.toString(),
      'done': done.toString(),
      'direction': direction,
      'userId': userId.toString(),
      'field': field
    });
    if (!rp.isOk) return null;

    if (cacheKey != null) {
      sharedPreferences.setString(cacheKey, rp.bodyString!);
    }
    debugPrint(rp.bodyString);
    return GetTeamProjectListResult.fromJson(jsonDecode(rp.bodyString!));
  }

  Future<bool> setUserOrganization(String organization) async {
    Response rp =
        await patch('/api/users/${Uri.encodeComponent(organization)}', {});
    return rp.statusCode == 204;
  }

  Future<List<WeteamNotification>?> getAlarms(int page) async {
    Map<String, dynamic> query = {
      'page': page.toString(),
      'size': 20.toString(),
      'sort': 'desc'
    };

    Response rp = await get('/api/alarms', query: query);
    if (!rp.isOk) return null;

    List alarmList = jsonDecode(rp.bodyString ?? '{}')['alarmList'] ?? [];
    List<WeteamNotification> ret = [];

    for (var element in alarmList) {
      ret.add(WeteamNotification.fromJson(element));
    }

    return ret;
  }

  Future<List<WeteamProjectUser>?> getProjectUsers(int projectId) async {
    Response rp = await get('/api/project-users/$projectId');
    if (!rp.isOk) return null;

    debugPrint(rp.bodyString);

    List data = jsonDecode(rp.bodyString ?? '[]');
    List<WeteamProjectUser> ret = List<WeteamProjectUser>.generate(
        data.length, (index) => WeteamProjectUser.fromJson(data[index]));

    return ret;
  }

  Future<bool> changeUserTeamProjectRole(TeamProject team, String role) async {
    Response rp = await patch('/api/project-users', {}, query: {
      'projectId': team.id.toString(),
      'role': role
    });

    return rp.statusCode == 204;
  }

  Future<bool> changeTeamProjectHost(int projectId, int userId) async {
    Response rp = await patch('/api/projects/$projectId/$userId', {});
    debugPrint(rp.bodyString);
    return rp.statusCode == 204;
  }

  Future<bool> kickUserFromTeamProject(List<int> teamUserIdList) async {
    String query = "";
    for (int i = 0; i < teamUserIdList.length; i++) {
      int teamUserId = teamUserIdList[i];
      query += 'projectUserIdList=$teamUserId';
      if (i != teamUserIdList.length - 1) {
        query += '&';
      }
    }
    Response rp = await delete('/api/project-users?$query');
    return rp.statusCode == 204;
  }

  Future<bool> acceptInvite(int projectId) async {
    Response rp = await patch('/api/project-users/$projectId', {});
    debugPrint(rp.bodyString);
    return rp.statusCode == 204;
  }

  Future<bool> deleteTeamProject(int projectId) async {
    Response rp = await delete('/api/projects/$projectId');
    debugPrint(rp.bodyString);
    return rp.statusCode == 204;
  }

  Future<bool> exitTeamProject(int projectId) async {
    Response rp = await delete('/api/project-users/$projectId');
    debugPrint(rp.bodyString);
    return rp.statusCode == 204;
  }

  Future<bool> readAlarmsAll() async {
    Response rp = await patch('/api/alarms', {});
    return rp.statusCode == 204;
  }

  Future<bool> readAlarm(int id) async {
    Response rp = await patch('/api/alarms/$id', {});
    return rp.statusCode == 204;
  }
}

class GetTeamProjectListResult {
  final int totalPages;
  final int totalElements;
  final List<TeamProject> projectList;

  const GetTeamProjectListResult(
      {required this.totalPages,
      required this.totalElements,
      required this.projectList});

  factory GetTeamProjectListResult.fromJson(Map data) {
    List tpList = data['projectList'];
    return GetTeamProjectListResult(
        totalPages: data['totalPages'],
        totalElements: data['totalElements'],
        projectList: List<TeamProject>.generate(
            tpList.length, (index) => TeamProject.fromJson(tpList[index])));
  }
}


// WTMProjectList

class GetWTMProjectListResult {
  final int totalPages;
  final int totalElements;
  final List<TeamProject> projectList;

  const GetWTMProjectListResult(
      {required this.totalPages,
      required this.totalElements,
      required this.projectList});

  factory GetWTMProjectListResult.fromJson(Map data) {
    List wtmList = data['wtmList'];
    return GetWTMProjectListResult(
        totalPages: data['totalPages'],
        totalElements: data['totalElements'],
        projectList: List<TeamProject>.generate(
            wtmList.length, (index) => TeamProject.fromJson(wtmList[index])));
  }
}
