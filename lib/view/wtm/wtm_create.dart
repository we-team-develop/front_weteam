import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/tp_controller.dart';
import '../../controller/wtm_controller.dart';
import '../../data/color_data.dart';
import '../../data/image_data.dart';
import '../widget/team_project_widget.dart';

class WTMCreate extends GetView<WTMController> {
  WTMCreate({Key? key}) : super(key: key);

  final TeamPlayController teamPlayController = Get.find<TeamPlayController>();

  @override
  StatelessElement createElement() {
    controller.updateTeamProject(controller.selectedtpList.value == "완료된 팀플");

    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 68.h, left: 15.w),
            child: _head(),
          ),
          SizedBox(
            height: 16.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: _search(),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  _tplist(
                      "진행중인 팀플", controller.selectedtpList.value == "진행중인 팀플"),
                ],
              )),
              Expanded(
                  child: _tplist(
                      "완료된 팀플", controller.selectedtpList.value == "완료된 팀플")),
            ],
          ),
          Column(
            children: controller.tpList.map((teamProject) {
              return TeamProjectWidget(teamProject);
            }).toList(),
          ),
          Center(
              child: Column(
            children: [
              _checkBox(),
              SizedBox(
                height: 16.h,
              ),
              _nextText(),
            ],
          )),
        ],
      );
    });
  }

  Widget _head() {
    return Text(
      '어떤 팀플의 약속인가요?',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'NanumGothic',
          fontSize: 20.sp),
    );
  }

  Widget _search() {
    return Container(
      width: 330.w,
      height: 49.h,
      padding: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.G_02, width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            ImagePath.icSearch,
            width: 36.w,
            height: 36.h,
          ),
        ],
      ),
    );
  }

  Widget _tplist(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.setSelectedtpList(text),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.MainOrange : Colors.transparent,
              width: 2.w,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.MainOrange : AppColors.G_02),
        ),
      ),
    );
  }

  Widget _checkBox() {
    return Container(
      width: 330.w,
      height: 46.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.G_02,
      ),
      child: Center(
        child: Text(
          '선택 완료',
          style: TextStyle(
            fontSize: 15.sp,
            fontFamily: 'NanumGothicExtraBold',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _nextText() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '팀플을 미선택 할래요. ',
            style: TextStyle(
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                fontSize: 10.sp),
          ),
          Text(
            '다음으로',
            style: TextStyle(
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
