import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/mainpage/tp_controller.dart';
import '../../controller/meeting/meeting_current_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../../model/meeting.dart';
import '../../model/team_project.dart';
import '../../model/weteam_user.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../util/weteam_utils.dart';
import '../meeting/meeting_current.dart';

class MeetingWidget extends StatelessWidget {
  final Meeting meeting;
  final bool showlink;

  const MeetingWidget(this.meeting, {super.key, this.showlink = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => GetBuilder(
          builder: (controller) => MeetingCurrent(),
          init: CurrentMeetingController(meeting))),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 53.h,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Obx(() {
                    meeting.rxProject; // 리스너에 가입
                    return _meetingImgWidget();
                  }),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _meetingTitleWidget(meeting.title),
                        Visibility(
                          visible: meeting.rxProject != null,
                            replacement: const SizedBox.shrink(),
                            child: Obx(() => _meetingTeamWidget(meeting.rxProject!.value)),
                        ),
                        _dateWidget(),
                      ],
                    ),
                  ),
                  if (showlink)
                    GestureDetector(
                      onTap: () async {
                        String? inviteLink = await Get.find<ApiService>()
                            .getMeetingInviteDeepLink(meeting.id);
                        WeteamUser currentUser =
                            Get.find<AuthService>().user.value!;

                        if (inviteLink == null) {
                          WeteamUtils.snackbar('', '초대 링크를 준비하지 못했어요',
                              icon: SnackbarIcon.fail);
                          return;
                        }

                        inviteLink =
                            Get.find<ApiService>().convertDeepLink(inviteLink);

                        Share.share(
                            '${currentUser.username}님이 [${meeting.title}] 언제보까에 초대했어요!\n$inviteLink');
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
    if (meeting.rxProject != null) {
      imageIndex = meeting.rxProject!.value.imageId;
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
          color: AppColors.g2),
    );
  }

  // TODO : meeting title
  Widget _meetingTitleWidget(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.black,
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
        color: AppColors.black,
        fontSize: 9.sp,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

  Widget _dateWidget() {
    return Text(
      "${_formattedDateTime(meeting.startedAt)} ~ ${_formattedDateTime(meeting.endedAt)}",
      style: TextStyle(
        color: AppColors.g4,
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
