import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/data/color_data.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/model/wtm_project.dart';

class WTMProjectWidget extends StatelessWidget {
  final WTMProject team;

  const WTMProjectWidget(this.team, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Row(
          children: [
            _wtmImgWidget(team.img),
            SizedBox(
              width: 14.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _wtmTitleWidget(team.title),
                _wtmTeamWidget(team.project),
                _dateWidget(),
              ],
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Image.asset(ImagePath.wtmlink)),
          ],
        ))
      ],
    );
  }

  Widget _wtmImgWidget(String img) {
    // TODO : 이미지
    return Container(
      width: 50.w,
      height: 50.h,
      decoration: ShapeDecoration(
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
    return "${dt.year}-${dt.month}-${dt.day}";
  }
}
