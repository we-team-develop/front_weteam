import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/team_project.dart';
import '../model/weteam_notification.dart';
import '../model/weteam_project_user.dart';
import '../model/weteam_user.dart';
import '../model/wtm_project.dart';
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

  /**
   * PROJECT
   */

  /// 팀플 목록 조회 API
  ///
  /// return: 성공시 GetTeamProjectListResult, 실패시 null
  Future<GetTeamProjectListResult?> getTeamProjectList(
      int page, bool done, String direction, String field, int userId,
      {String? cacheKey}) async {
    Response rp = await get('/api/projects', query: {
      'page': page.toString(),
      'size': 200.toString(),
      'done': done.toString(),
      'direction': direction,
      'userId': userId.toString(),
      'field': field
    });
    if (rp.hasError) return null;

    // 키를 받았다면 캐시에 json을 기록
    if (cacheKey != null) {
      sharedPreferences.setString(cacheKey, rp.bodyString!);
    }

    return GetTeamProjectListResult.fromJson(jsonDecode(rp.bodyString!));
  }

  /// wtm 목록 조회 API
  ///
  /// return: 성공시 GetWTMProjectListResult, 실패시 null
  Future<GetWTMProjectListResult?> getWTMProjectList(
      int page, String direction, String field) async {
    Response rp = await get('/api/projects', query: {
      'page': page.toString(),
      'size': 200.toString(),
      'direction': direction,
      'field': field
    });

    if (rp.hasError) return null;
    return GetWTMProjectListResult.fromJson(jsonDecode(rp.bodyString!));
  }

  /// wtm 단건 조회 API
  ///
  /// return: 성공시  wtmProject, 실패시 null
  Future<WTMProject?> getWTMProject(int projectId) async {
    Response rp = await get('/api/meetings/$projectId');
    if (rp.hasError) return null;

    String json = rp.bodyString ?? "{}";
    Map data = jsonDecode(json);

    return WTMProject.fromJson(data);
  }

  /// wtm 생성 API
  ///
  /// return: 성공 여부
  // Future<bool>

  /// 팀플 생성 API
  ///
  /// return: 성공 여부
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
    Response rp = await post('/api/projects', data);
    return rp.isOk;
  }

  /// 팀플 단건 조회 API
  ///
  /// return: 성공시  TeamProject, 실패시 null
  Future<TeamProject?> getTeamProject(int projectId) async {
    Response rp = await get('/api/projects/$projectId');
    if (rp.hasError) return null;

    String json = rp.bodyString ?? "{}";
    Map data = jsonDecode(json);

    return TeamProject.fromJson(data);
  }

  /// 팀플 삭제 API
  ///
  /// return: 성공 여부
  Future<bool> deleteTeamProject(int projectId) async {
    Response rp = await delete('/api/projects/$projectId');
    return rp.isOk;
  }

  /// 팀플 수정 API
  ///
  /// return: 성공 여부
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
    return rp.isOk;
  }

  /// 팀플 호스트 변경 API
  ///
  /// return: 성공 여부
  Future<bool> changeTeamProjectHost(int projectId, int userId) async {
    Response rp = await patch('/api/projects/$projectId/$userId', {});
    return rp.isOk;
  }

  /**
   * PROFILE
   */

  /// 프로필 생성 API (회원가입)
  ///
  /// return: 성공 여부
  Future<bool> createUserProfiles(int imageIdx) async {
    Response rp = await post('/api/profiles/$imageIdx', {});
    return rp.isOk;
  }

  /// 프로필 변경 API
  ///
  /// return: 성공 여부
  Future<bool> changeUserProfiles(int imageIdx) async {
    Response rp = await patch('/api/profiles/$imageIdx', {});
    return rp.isOk;
  }

  /**
   * MEETING
   */

  /// 미팅 생성
  ///
  /// return: 성공 여부
  Future<bool> createWTM(
      {required String title,
      required DateTime startedAt,
      required DateTime endedAt,
      required int projectId}) async {
    Map<String, String> requestBody = {};
    requestBody['title'] = title;
    requestBody['startedAt'] =
    "${startedAt.year}-${startedAt.month.toString().padLeft(2, '0')}-${startedAt
        .day.toString().padLeft(2, '0')}T00:00:00";
    requestBody['endedAt'] =
    "${endedAt.year}-${endedAt.month.toString().padLeft(2, '0')}-${endedAt
        .day.toString().padLeft(2, '0')}T00:00:00";
    requestBody['projectId'] = '$projectId';
    Response rp = await post('/api/meetings', requestBody);

    return rp.isOk;
  }

  /**
   * USER
   */

  /// 유저 소속 설정 API
  ///
  /// return: 성공 여부
  Future<bool> setUserOrganization(String organization) async {
    Response rp =
        await patch('/api/users/${Uri.encodeComponent(organization)}', {});
    return rp.isOk;
  }

  /// 현재 유저 정보 조회 API
  ///
  /// return: 성공시 WeteamUser, 실패시 null
  Future<WeteamUser?> getCurrentUser() async {
    Response rp = await get('/api/users');
    if (rp.hasError) {
      return null;
    }

    String? json = rp.bodyString;
    if (json == null) {
      return null;
    }

    sharedPreferences.setString(SharedPreferencesKeys.weteamUserJson, json);

    return WeteamUser.fromJson(jsonDecode(json));
  }

  /// 회원탈퇴 API
  ///
  /// * return: 탈퇴 성공 여부
  Future<bool> withdrawal() async {
    Response rp = await delete('/api/users');
    return rp.isOk;
  }

  /**
   * PROJECT_USER
   */

  /// 팀원 강퇴 API
  ///
  /// return: 성공 여부
  Future<bool> kickUserFromTeamProject(List<int> teamUserIdList) async {
    // 쿼리 생성
    String query = "";
    for (int i = 0; i < teamUserIdList.length; i++) {
      int teamUserId = teamUserIdList[i];
      query += 'projectUserIdList=$teamUserId';

      // 마지막 요소가 아닌지 확인
      if (i != teamUserIdList.length - 1) {
        query += '&'; // 다음 요소를 위해 & 추가
      }
    }

    Response rp = await delete('/api/project-users?$query');
    return rp.isOk;
  }

  /// 유저 팀플 담당 역할 변경 API
  ///
  /// return: 성공 여부
  Future<bool> changeUserTeamProjectRole(TeamProject team, String role) async {
    Response rp = await patch('/api/project-users', {},
        query: {'projectId': team.id.toString(), 'role': role});

    return rp.isOk;
  }

  /// 팀플 팀원 목록 조회 API
  ///
  /// return: 성공시 WeteamProjectUser 리스트, 실패시 null
  Future<List<WeteamProjectUser>?> getProjectUsers(int projectId) async {
    Response rp = await get('/api/project-users/$projectId');
    if (rp.hasError) return null;

    List data = jsonDecode(rp.bodyString ?? '[]');
    List<WeteamProjectUser> ret = List<WeteamProjectUser>.generate(
        data.length, (index) => WeteamProjectUser.fromJson(data[index]));

    return ret;
  }

  /// 팀플 탈퇴 API
  ///
  /// return: 성공 여부
  Future<bool> exitTeamProject(int projectId) async {
    Response rp = await delete('/api/project-users/$projectId');
    return rp.isOk;
  }

  /// 팀플 초대 수락 API
  ///
  /// return: 성공 여부
  Future<bool> acceptInvite(int projectId) async {
    Response rp = await patch('/api/project-users/$projectId', {});
    return rp.isOk;
  }

  /**
   * FCM
   */

  Future<bool> setFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) return false;
    Response rp = await patch('/api/fcm/$fcmToken', {});

    return rp.isOk;
  }

  /**
   * ALARM
   */

  /// 유저 알림 목록 조회 API
  ///
  /// return: 성공시 위팀 알림 객제 리스트, 실패시 null
  Future<List<WeteamNotification>?> getAlarms(int page) async {
    Map<String, dynamic> query = {
      'page': page.toString(),
      'size': 20.toString(),
      'sort': 'desc'
    };

    Response rp = await get('/api/alarms', query: query);
    if (rp.hasError) return null;

    List alarmList = jsonDecode(rp.bodyString ?? '{}')['alarmList'] ?? [];
    List<WeteamNotification> ret = [];

    for (var element in alarmList) {
      ret.add(WeteamNotification.fromJson(element));
    }

    return ret;
  }

  /// 알림 전체 읽음 처리 API
  ///
  /// return: 성공 여부
  Future<bool> readAlarmsAll() async {
    Response rp = await patch('/api/alarms', {});
    return rp.isOk;
  }

  /// 특정 알림 읽음 처리 API
  ///
  /// return: 성공 여부
  Future<bool> readAlarm(int id) async {
    Response rp = await patch('/api/alarms/$id', {});
    return rp.isOk;
  }
}

// 팀플 조회 API의 결과에 대한 객체
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

// WTM 조회 API의 결과에 대한 객체
class GetWTMProjectListResult {
  final int totalPages;
  final int totalElements;
  final List<WTMProject> wtmprojectList;

  const GetWTMProjectListResult(
      {required this.totalPages,
      required this.totalElements,
      required this.wtmprojectList});

  factory GetWTMProjectListResult.fromJson(Map data) {
    List wtmList = data['wtmList'];
    return GetWTMProjectListResult(
        totalPages: data['totalPages'],
        totalElements: data['totalElements'],
        wtmprojectList: List<WTMProject>.generate(
            wtmList.length, (index) => WTMProject.fromJson(wtmList[index])));
  }
}
