import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/mainpage/tp_controller.dart';
import '../../controller/meeting/meeting_current_controller.dart';
import '../../data/color_data.dart';
import '../../data/image_data.dart';
import '../../model/team_project.dart';
import '../../model/weteam_user.dart';
import '../../model/meeting.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../util/weteam_utils.dart';
import '../meeting/meeting_current.dart';

class MeetingWidget extends StatelessWidget {
  final Meeting team;
  final bool showlink;

  const MeetingWidget(this.team, {super.key, this.showlink = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => GetBuilder(
          builder: (controller) => MeetingCurrent(),
          init: CurrentMeetingController(team))),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 53.h,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _meetingImgWidget(),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _meetingTitleWidget(team.title),
                        if (team.project != null) _meetingTeamWidget(team.project!),
                        _dateWidget(),
                      ],
                    ),
                  ),
                  if (showlink)
                    GestureDetector(
                      onTap: () async {
                        String? inviteLink = await Get.find<ApiService>()
                            .getMeetingInviteLink(team.id);
                        WeteamUser currentUser =
                            Get.find<AuthService>().user.value!;

                        if (inviteLink == null) {
                          WeteamUtils.snackbar('', '초대 링크를 준비하지 못했어요', icon: SnackbarIcon.fail);
                          return;
                        }

                        inviteLink = Get.find<ApiService>().getDeepLinkUrl(inviteLink);

                        Share.share(
                            '${currentUser.username}님이 [${team.title}] 언제보까에 초대했어요!\n$inviteLink');
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(ImagePath.meetingLink,
                              width: 13.5.w, height: 15.h)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _meetingImgWidget() {
    TeamPlayController controller = Get.find<TeamPlayController>();

    int imageIndex = 0;
    if (team.project != null) {
      imageIndex = team.project!.imageId;
    } else {
      imageIndex = Random().nextInt(controller.imagePaths.length);
    }

    return Container(
      width: 50.w,
      height: 50.h,
      decoration: ShapeDecoration(
          image: DecorationImage(
              image: AssetImage(controller.imagePaths[imageIndex]),
              fit: BoxFit.fill),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          color: AppColors.G_02),
    );
  }

  // TODO : meeting title
  Widget _meetingTitleWidget(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.Black,
        fontSize: 12.sp,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w700,
        height: 0,
      ),
    );
  }

  Widget _meetingTeamWidget(TeamProject project) {
    return Text(
      "팀플명 : ${project.title}",
      style: TextStyle(
        color: AppColors.Black,
        fontSize: 9.sp,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

  Widget _dateWidget() {
    return Text(
      "${_formattedDateTime(team.startedAt)} ~ ${_formattedDateTime(team.endedAt)}",
      style: TextStyle(
        color: AppColors.G_04,
        fontSize: 9.sp,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

  String _formattedDateTime(DateTime dt) {
    return "${dt.year}.${dt.month}.${dt.day}";
  }
}