import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/view/teamplay/team_project_detail_page.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

import 'controller/bottom_nav_controller.dart';
import 'controller/mainpage/home_controller.dart';
import 'controller/meeting/meeting_current_controller.dart';
import 'controller/team_project_detail_page_controller.dart';
import 'data/app_colors.dart';
import 'data/image_data.dart';
import 'model/meeting.dart';
import 'model/team_project.dart';
import 'model/weteam_user.dart';
import 'service/api_service.dart';
import 'service/auth_service.dart';
import 'service/team_project_service.dart';
import 'util/weteam_utils.dart';
import 'view/home/home.dart';
import 'view/meeting/meeting_current.dart';
import 'view/my/mypage.dart';
import 'view/teamplay/teamplay.dart';

class App extends GetView<BottomNavController> {
  const App({super.key});

  @override
  StatelessElement createElement() {
    linkStream.listen((event) async {
      if (event == null) return;

      bool isLoggedIn = Get.find<AuthService>().user.value != null;
      Uri uri = Uri.parse(event);
      ApiService api = Get.find<ApiService>();

      String host = uri.host;
      String path = uri.path;
      Map<String, String> query = uri.queryParameters;

      WeteamUser? user = Get.find<AuthService>().user.value;

      try {
        // 예외 처리되지 않은 오류 핸들링
        if (host == "projects") {
          if (path.startsWith("/acceptInvite")) {
            String hashedId = query['id'] ?? '-1';
            if (!isLoggedIn) return;

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
                0, true, 'DESC', 'DONE', user!.id);

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
              await Get.find<HomeController>().updateTeamProjectList();
              
              WeteamUtils.snackbar("", '팀플 초대를 성공적으로 수락했어요',
                  icon: SnackbarIcon.success);
              Get.to(() => GetBuilder(
                  builder: (controller) => const TeamProjectDetailPage(),
                  init: TeamProjectDetailPageController(
                      tps.getTeamProjectByHashedId(hashedId)!)));
            } else {
              WeteamUtils.snackbar("", '오류가 발생하여 팀플 초대를 수락하지 못했어요',
                  icon: SnackbarIcon.fail);
              return;
            }
          }
        } else if (host == "meeting") {
          if (path.startsWith('/acceptInvite')) {
            String hashedId = query['id'] ?? '';

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
        }
      } catch (e) {
        WeteamUtils.snackbar('', '요청을 처리하지 못했어요', icon: SnackbarIcon.fail);
        return;
      }
    });
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        // 뒤로가기 담당
        canPop: true,
        onPopInvoked: (didPop) {
          controller.popAction();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false, // 키보드 픽셀 over 방지
          body: SafeArea(child: _body()),
          bottomNavigationBar: _bottom(context),
        ),
      ),
    );
  }

  Widget _bottom(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // 색상
            spreadRadius: 10.r, // 그림자 확산 범위
            blurRadius: 15, // 그림자의 흐림 정도, 값이 클수록 흐릿해지면서 가장자리가 부드러워짐
            offset: Offset(0, 8.h), // 그림자 위치 y축으로 아래로 1만큼 감.
          ),
        ],
      ),
      // ios기기에서 발생하는 오버플로 현상 해결
      child: OverflowBox(
        maxHeight: double.infinity,
        child: BottomNavigationBar(
          currentIndex: controller.index,
          onTap: controller.changeIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.mainOrange,
          unselectedItemColor: AppColors.g4,
          selectedLabelStyle: TextStyle(fontSize: 8.sp),
          unselectedLabelStyle: TextStyle(fontSize: 8.sp),
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(ImagePath.tpOff, width: 25.w, height: 25.h),
                activeIcon:
                    Image.asset(ImagePath.tpOn, width: 25.w, height: 25.h),
                label: '진행팀플'),
            BottomNavigationBarItem(
                icon: Image.asset(ImagePath.homeOff, width: 25.w, height: 25.h),
                activeIcon:
                    Image.asset(ImagePath.homeOn, width: 25.w, height: 25.h),
                label: '홈'),
            BottomNavigationBarItem(
                icon: Image.asset(ImagePath.myOff, width: 25.w, height: 25.h),
                activeIcon:
                    Image.asset(ImagePath.myOn, width: 25.w, height: 25.h),
                label: '마이'),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return IndexedStack(
      index: controller.index,
      children: const [
        TeamPlay(),
        Home(),
        MyPage(),
      ],
    );
  }
}
