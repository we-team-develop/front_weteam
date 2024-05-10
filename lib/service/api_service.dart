import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../controller/mainpage/tp_controller.dart';
import '../controller/meeting/meeting_current_controller.dart';
import '../main.dart';
import '../model/meeting.dart';
import '../model/meeting_detail.dart';
import '../model/team_project.dart';
import '../model/weteam_alarm.dart';
import '../model/weteam_project_user.dart';
import '../model/weteam_user.dart';
import '../util/custom_get_connect.dart';
import '../util/weteam_utils.dart';
import 'auth_service.dart';
import 'team_project_service.dart';

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

    WeteamUser? user = Get.find<AuthService>().user.value;
    bool isMyTeamProject = user?.id == userId;

    return GetTeamProjectListResult.fromJson(jsonDecode(rp.bodyString!), isMyTeamProject);
  }

  /// 팀플 생성 API
  ///
  /// return: 성공 여부
  Future<bool> createTeamProject(String name, DateTime startedAt,
      DateTime endedAt, String explanation) async {
    TeamPlayController controller = Get.find<TeamPlayController>();
    int randomImageIndex = Random().nextInt(controller.imagePaths.length);
    Map data = {
      'name': name,
      'startedAt':
          "${startedAt.year}-${startedAt.month.toString().padLeft(2, '0')}-${startedAt.day.toString().padLeft(2, '0')}",
      'endedAt':
          "${endedAt.year}-${endedAt.month.toString().padLeft(2, '0')}-${endedAt.day.toString().padLeft(2, '0')}",
      'explanation': explanation,
      'imageId': randomImageIndex.toString()
    };
    Response rp = await post('/api/projects', data);
    return rp.isOk;
  }

  /// 팀플 단건 조회 API
  ///
  /// return: 성공시  RxTeamProject, 실패시 null
  Future<RxTeamProject?> getTeamProject(int projectId) async {
    Response rp = await get('/api/projects/$projectId');
    if (rp.hasError) return null;

    String json = rp.bodyString ?? "{}";
    Map data = jsonDecode(json);

    TeamProjectService tpService = Get.find<TeamProjectService>();
    RxTeamProject? oldRxTp = tpService.getTeamProjectById(projectId);
    TeamProject tp = TeamProject.fromJson(data);

    if (oldRxTp != null) {
      return tpService.updateEntry(tp);
    } else {
      return RxTeamProject(tp);
    }
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

  Future<bool> togglePushAlarmStatus() async {
    Response rp = await patch('/api/users', {});
    return rp.isOk;
  }

  /**
   * MEETING
   */

  /// 미팅 생성
  ///
  /// return: [Meeting]?
  Future<Meeting?> createMeeting(
      {required String title,
      required DateTime startedAt,
      required DateTime endedAt,
      required int? projectId}) async {
    startedAt = WeteamUtils.onlyDate(startedAt);
    endedAt = WeteamUtils.onlyDate(endedAt);

    TeamPlayController controller = Get.find<TeamPlayController>();
    int randomImageIndex = Random().nextInt(controller.imagePaths.length);

    Map<String, String> requestBody = {
      'title': title,
      'startedAt': WeteamUtils.formatDateTime(startedAt, withTime: true),
      'endedAt': WeteamUtils.formatDateTime(endedAt, withTime: true),
      'imageId': randomImageIndex.toString(),
    };

    // 팀플을 선택하는 미팅일 경우 팀플 ID를 추가해줍니다.
    if (projectId != null) {
      requestBody['projectId'] = '$projectId';
    }

    // 서버로 API요청
    Response rp = await post('/api/meetings', requestBody);

    // 오류 발생시 null return
    if (rp.hasError || rp.bodyString == null) {
      return null;
    }

    return Meeting.fromJson(json.decode(rp.bodyString!));
  }

  /// 미팅 수정
  ///
  /// return: [bool]
  Future<bool> editMeeting(
      {required int meetingId,
      required String title,
      required DateTime startedAt,
      required DateTime endedAt}) async {
    startedAt = WeteamUtils.onlyDate(startedAt);
    endedAt = WeteamUtils.onlyDate(endedAt);

    Map<String, String> requestBody = {
      'title': title,
      'startedAt': WeteamUtils.formatDateTime(startedAt, withTime: true),
      'endedAt': WeteamUtils.formatDateTime(endedAt, withTime: true),
    };

    // 서버로 API요청
    Response rp = await patch('/api/meetings/$meetingId', requestBody);

    return rp.isOk;
  }

  /// meeting 목록 조회 API
  ///
  /// return: 성공시 GetMeetingProjectListResult, 실패시 null
  Future<GetMeetingListResult?> getMeetingList(
      int page, String direction, String field) async {
    Response rp = await get('/api/meetings', query: {
      'page': page.toString(),
      'size': 200.toString(),
      'direction': direction,
      'field': field,
      'sort': 'desc'
    });

    if (rp.hasError) return null;
    return GetMeetingListResult.fromJson(jsonDecode(rp.bodyString!));
  }

  /// meeting 단건 조회 API
  ///
  /// return: 성공시  Meeting, 실패시 null
  Future<Meeting?> getMeetingProject(int projectId) async {
    Response rp = await get('/api/meetings/$projectId');
    if (rp.hasError) return null;

    String json = rp.bodyString ?? "{}";
    Map data = jsonDecode(json);

    return Meeting.fromJson(data);
  }

  /// MEETING_USER

  Future<bool> setMeetingSchedule(
      int meetingId, List<MeetingTime> timeList) async {
    List<Map<String, String>> timeMapList = [];
    for (var element in timeList) {
      timeMapList.add(element.toMap());
    }

    Response rp =
        await patch('/api/meeting-users/$meetingId/time', timeMapList);
    return rp.isOk;
  }

  Future<MeetingDetail?> getMeetingDetail(int meetingId) async {
    Response rp = await get('/api/meetings/$meetingId');
    if (rp.hasError || rp.body == null) {
      return null;
    }

    return MeetingDetail.fromJson(rp.body);
  }

  Future<String?> getMeetingInviteDeepLink(int meetingId) async {
    Response rp = await get('/api/meeting-users/$meetingId');
    String? hashedId = rp.bodyString?.trim();

    if (hashedId == null) {
      return null;
    }

    return "weteam://meeting/acceptInvite?id=$hashedId";
  }

  Future<bool> acceptMeetingInvite(String hashedId) async {
    Response rp = await patch("/api/meeting-users/$hashedId", {});
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

  /// 팀플 팀원 초대 링크 생성 api
  ///
  /// return: 성공시 url(String), 실패시 null
  Future<String?> getTeamProjectInviteDeepLink(int projectId) async {
    Response rp = await get('/api/project-users/$projectId/invite');
    if (rp.hasError) return null;

    return "weteam://projects/acceptInvite?id=${rp.bodyString}";
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
  Future<bool> acceptProjectInvite(String hashedId) async {
    Response rp = await patch('/api/project-users/$hashedId', {});
    return rp.isOk;
  }

  /// FCM

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
  Future<List<WeteamAlarm>?> getAlarms(int page) async {
    Map<String, dynamic> query = {
      'page': page.toString(),
      'size': 10.toString(),
      'direction': 'DESC',
      'field': 'ALARM_DATE',
    };

    Response rp = await get('/api/alarms', query: query);
    if (rp.hasError) return null;

    List alarmList = jsonDecode(rp.bodyString ?? '{}')['alarmList'] ?? [];
    List<WeteamAlarm> ret = [];

    for (var element in alarmList) {
      ret.add(WeteamAlarm.fromJson(element));
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

  /// 딥링크용 url 반환 API
  ///
  /// return: String - 딥링크 실행용 url
  String convertDeepLink(String url) {
    url = Uri.encodeComponent(url);
    return "$_baseUrl/api/common?url=$url";
  }
}

// 팀플 조회 API의 결과에 대한 객체
class GetTeamProjectListResult {
  final int totalPages;
  final int totalElements;
  final List<RxTeamProject> rxProjectList;
  final bool myTeamProject;

  const GetTeamProjectListResult(
      {required this.totalPages,
      required this.totalElements,
      required this.rxProjectList,
      required this.myTeamProject});

  factory GetTeamProjectListResult.fromJson(Map data, bool myTeamProject) {
    List tpList = data['projectList'];
    TeamProjectService tps = Get.find<TeamProjectService>();

    return GetTeamProjectListResult(
        totalPages: data['totalPages'],
        totalElements: data['totalElements'],
        rxProjectList: List<RxTeamProject>.generate(
            tpList.length, (index) => myTeamProject
              ? tps.getTeamProjectById(TeamProject.fromJsonAndUpdate(tpList[index]).id)!
              : RxTeamProject.updateOrCreate(TeamProject.fromJson(tpList[index]))),
        myTeamProject: myTeamProject
    );
  }
}

// Meeting 조회 API의 결과에 대한 객체
class GetMeetingListResult {
  final int totalPages;
  final int totalElements;
  final List<Meeting> meetingList;

  const GetMeetingListResult(
      {required this.totalPages,
      required this.totalElements,
      required this.meetingList});

  factory GetMeetingListResult.fromJson(Map data) {
    List meetingList = data['meetingDtoList'];
    return GetMeetingListResult(
        totalPages: data['totalPages'],
        totalElements: data['totalElements'],
        meetingList: List<Meeting>.generate(meetingList.length,
            (index) => Meeting.fromJson(meetingList[index])));
  }
}
