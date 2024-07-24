import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

import '../controller/meeting/meeting_current_controller.dart';
import '../controller/team_project_detail_page_controller.dart';
import '../model/meeting.dart';
import '../model/weteam_user.dart';
import '../service/api_service.dart';
import '../service/auth_service.dart';
import '../service/team_project_service.dart';
import '../view/meeting/meeting_current.dart';
import '../view/teamplay/team_project_detail_page.dart';
import '../view/widget/loading_overlay.dart';
import 'weteam_utils.dart';

class DeepLinkService extends GetxService {
  late String path;
  late Map<String, String> query;

  @override
  void onInit() {
    super.onInit();
    listen();
  }

  void listen() {
    linkStream.listen((event) async {
      if (event == null) return;

      bool isLoggedIn = Get.find<AuthService>().user.value != null;
      Uri uri = Uri.parse(event);
      ApiService api = Get.find<ApiService>();

      String host = uri.host;
      path = uri.path;
      query = uri.queryParameters;

      if (!isLoggedIn) return;

      try {
        // 예외 처리되지 않은 오류 핸들링
        if (host == "projects") {
          if (path.startsWith('/acceptInvite')) {
            _showOverlay(_acceptTeamProjectInvite, '팀플에 참여하고 있어요');
          }
        } else if (host == "meeting") {
          if (path.startsWith('/acceptInvite')) {
            _showOverlay(_acceptMeetingInvite, '언제보까에 참여하고 있어요');
          }
        }
      } catch (e, st) {
        WeteamUtils.snackbar('', '요청을 처리하지 못했어요', icon: SnackbarIcon.fail);
        debugPrint("$e");
        debugPrintStack(stackTrace: st);
        return;
      }
    });
  }

  Future _showOverlay(Future Function() func, String title) {
    return Get.showOverlay(asyncFunction: func,
        loadingWidget: LoadingOverlay(title: title),
        opacity: 0);
  }

  Future<void> _acceptMeetingInvite() async {
    String hashedId = query['id'] ?? '';
    ApiService api = Get.find<ApiService>();

    // 올바르지 않은 id
    if (hashedId.isEmpty) {
      WeteamUtils.snackbar('', '올바르지 않은 언제보까 초대예요',
          icon: SnackbarIcon.fail);
      return;
    }

    GetMeetingListResult? meetings = await api.getMeetingList(0, 'DESC', 'STARTED_AT');
    if (meetings == null) {
      WeteamUtils.snackbar('언제보까에 참여할 수 없어요', '잠시 후 다시 시도해주세요',
          icon: SnackbarIcon.fail);
      return;
    }

    for (Meeting mt in meetings.meetingList) {
      if (mt.hashedId == hashedId) {
        WeteamUtils.snackbar("", '이미 가입한 언제보까예요',
            icon: SnackbarIcon.fail);
        return;
      }
    }

    bool success = await api.acceptMeetingInvite(hashedId);
    if (success) {

      GetMeetingListResult? meetings = await api.getMeetingList(0, 'DESC', 'STARTED_AT');
      if (meetings == null) {
        WeteamUtils.snackbar('언제보까에 참여할 수 없어요', '잠시 후 다시 시도해주세요',
            icon: SnackbarIcon.fail);
        return;
      }

      for (Meeting mt in meetings.meetingList) {
        if (mt.hashedId == hashedId) {
          Get.to(() => GetBuilder(
              builder: (controller) => MeetingCurrent(),
              init: CurrentMeetingController(mt)));
        }
      }

      WeteamUtils.snackbar("", '언제보까 초대를 성공적으로 수락했어요',
          icon: SnackbarIcon.success);
    } else {
      WeteamUtils.snackbar("", '오류가 발생하여 팀플 초대를 수락하지 못했어요',
          icon: SnackbarIcon.fail);
    }
  }

  Future<void> _acceptTeamProjectInvite() async {
    WeteamUser? user = Get.find<AuthService>().user.value;
    ApiService api = Get.find<ApiService>();

    String hashedId = query['id'] ?? '-1';

    GetTeamProjectListResult? notDoneProjects = await Get.find<
        ApiService>().getTeamProjectList(
        0, false, 'DESC', 'DONE', user!.id);

    if (notDoneProjects == null) {
      WeteamUtils.snackbar("", '팀플 가입 여부를 확인하지 못했어요',
          icon: SnackbarIcon.fail);
      return;
    }

    for (RxTeamProject rxTp in notDoneProjects.rxProjectList) {
      if (rxTp.value.hashedId == hashedId) {
        WeteamUtils.snackbar("", '이미 가입한 팀플이에요',
            icon: SnackbarIcon.fail);
        return;
      }
    }

    GetTeamProjectListResult? doneProjects = await Get.find<
        ApiService>().getTeamProjectList(
        0, true, 'DESC', 'DONE', user.id);

    if (doneProjects == null) {
      WeteamUtils.snackbar("", '팀플 가입 여부를 확인하지 못했어요.',
          icon: SnackbarIcon.fail);
      return;
    }

    for (RxTeamProject rxTp in doneProjects.rxProjectList) {
      if (rxTp.value.hashedId == hashedId) {
        WeteamUtils.snackbar("", '이미 가입한 팀플이에요',
            icon: SnackbarIcon.fail);
        return;
      }
    }

    bool success = await api.acceptProjectInvite(hashedId);

    if (success) {
      TeamProjectService tps = Get.find<TeamProjectService>();
      bool updateSuccess = await tps.updateLists();

      WeteamUtils.snackbar("", '팀플 초대를 성공적으로 수락했어요',
          icon: SnackbarIcon.success);

      if (updateSuccess) {
        Get.to(() =>
            GetBuilder(
                builder: (controller) => const TeamProjectDetailPage(),
                init: TeamProjectDetailPageController(
                    tps.getTeamProjectByHashedId(hashedId)!)));
      }
    } else {
      WeteamUtils.snackbar("", '오류가 발생하여 팀플 초대를 수락하지 못했어요',
          icon: SnackbarIcon.fail);
      return;
    }
  }
}