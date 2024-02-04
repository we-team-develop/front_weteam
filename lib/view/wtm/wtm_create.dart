import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/tp_controller.dart';
import 'package:front_weteam/controller/wtm_controller.dart';
import 'package:front_weteam/data/color_data.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/view/widget/team_project_widget.dart';
import 'package:get/get.dart';

class WTMCreate extends GetView<WTMController> {
  WTMCreate({super.key});

  final overlayKey = GlobalKey();

  final TeamPlayController teamPlayController = Get.find<TeamPlayController>();

  @override
  Widget build(BuildContext context) {
    print('check build method');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('showOverlay is being called');
      showOverlay(context);
    });
    return Scaffold(
      key: overlayKey,
      body: _body(),
    );
  }

  void showOverlay(BuildContext context) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          const Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: true, color: Colors.black),
          ),
          Center(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  Widget _body() {
    return Obx(() {
      print('check obx');
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
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 15.w),
            child: SingleChildScrollView(
              child: Column(
                children: controller.tpList.map((teamProject) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Row(children: [
                        Expanded(child: TeamProjectWidget(teamProject)),
                        SizedBox(width: 16.w),
                        GestureDetector(onTap: () {
                          controller.selectedTeamProject.value = teamProject;
                        }, child: Obx(() {
                          bool isSelected =
                              controller.selectedTeamProject.value?.id ==
                                  teamProject.id;
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 9.w, vertical: 4.h),
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.Orange_03
                                    : AppColors.G_02,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              '선택',
                              style: TextStyle(
                                  color: isSelected
                                      ? AppColors.White
                                      : AppColors.G_05,
                                  fontFamily: 'NanumSquareNeo',
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold),
                            )),
                          );
                        }))
                      ]));
                }).toList(),
              ),
            ),
          )),
          Center(
              child: Column(
            children: [
              _checkBox(),
              SizedBox(height: 16.h),
              _nextText(),
              SizedBox(height: 15.h),
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
    return Obx(() => Container(
          width: 330.w,
          height: 46.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: controller.selectedTeamProject.value != null
                ? AppColors.MainOrange
                : AppColors.G_02,
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
        ));
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
                color: AppColors.G_05,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp),
          ),
          Text(
            '다음으로',
            style: TextStyle(
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                color: AppColors.G_05,
                decoration: TextDecoration.underline,
                fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
