import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/model/team_project.dart';

class TeamProjectWidget extends StatelessWidget {
  final TeamProject team;

  const TeamProjectWidget(
      this.team,
      {super.key});
  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return SizedBox(
      height: 53.h,
      child: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              _teamImgWidget(team.img),
              SizedBox(width: 16.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _teamTitleWidget(team.title),
                  _teamDescriptionWidget(team.description),
                  Row(
                    children: [
                      _teamMemberCountWidget(team.memberSize),
                      SizedBox(width: 31.w),
                      _dateWidget(team.date),
                    ],
                  )
                ],
              )
            ],
          )),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _teamImgWidget(String img) {
    // TODO : 이미지 표시하기
    return Container(
      width: 50.w,
      height: 50.h,
      decoration: ShapeDecoration(
        color: const Color(0xFFD9D9D9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _teamTitleWidget(String title) {
    return Text(
      title,
      style: TextStyle(
        color: const Color(0xFF333333),
        fontSize: 11.sp,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w700,
        height: 0,
      ),
    );
  }

  Widget _teamDescriptionWidget(String desc) {
    return Text(
      desc,
      style: TextStyle(
        color: const Color(0xFF333333),
        fontSize: 7.sp,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

  Widget _teamMemberCountWidget(int memberSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: [
        Image.asset(width: 6.w, height: 8.h, ImagePath.icGroup),
        SizedBox(width: 2.w),
        Text(
          "$memberSize",
          style: TextStyle(
            color: const Color(0xFF333333),
            fontSize: 7.sp,
            fontFamily: 'NanumSquareNeo',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _dateWidget(String date) {
    return Text(
      team.date,
      style: TextStyle(
        color: const Color(0xFF969696),
        fontSize: 7.sp,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

}