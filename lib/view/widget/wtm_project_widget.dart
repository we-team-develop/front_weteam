import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/mainpage/tp_controller.dart';
import '../../controller/wtm/wtm_current_controller.dart';
import '../../data/color_data.dart';
import '../../data/image_data.dart';
import '../../model/team_project.dart';
import '../../model/wtm_project.dart';
import '../wtm/wtm_current.dart';

class WTMProjectWidget extends StatelessWidget {
  final WTMProject team;
  final bool showlink;

  const WTMProjectWidget(this.team, {super.key, this.showlink = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => GetBuilder(
          builder: (controller) => const WTMCurrent(),
          init: WTMCurrentController(team))),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 53.h,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _wtmImgWidget(),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _wtmTitleWidget(team.title),
                        if (team.project != null) _wtmTeamWidget(team.project!),
                        _dateWidget(),
                      ],
                    ),
                  ),
                  if (showlink)
                    Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset(ImagePath.wtmlink,
                            width: 13.5.w, height: 15.h)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wtmImgWidget() {
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
        image: DecorationImage(image: AssetImage(controller.imagePaths[imageIndex]), fit: BoxFit.fill),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          color: AppColors.G_02),
    );
  }

  // TODO : wtm title
  Widget _wtmTitleWidget(String title) {
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

  Widget _wtmTeamWidget(TeamProject project) {
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
