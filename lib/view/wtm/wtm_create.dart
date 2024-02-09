import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/tp_controller.dart';
import 'package:front_weteam/controller/wtm_controller.dart';
import 'package:front_weteam/data/color_data.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/view/widget/team_project_widget.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WTMCreate extends GetView<WTMController> {
  WTMCreate({super.key});

  final overlayKey = GlobalKey();
  final TeamPlayController teamPlayController = Get.find<TeamPlayController>();

  final Rx<OverlayEntry?> _overlayEntry = Rx<OverlayEntry?>(null);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOverlay(context);
    });
    return Scaffold(
      key: overlayKey,
      body: _body(),
    );
  }

  void _showOverlay(BuildContext context) {
    final PageController pageController = PageController();

    _overlayEntry.value = OverlayEntry(
      builder: (context) => SafeArea(child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 배경
            const ModalBarrier(dismissible: true, color: Color(0x80000000)),
            // 닫기 버튼
            Positioned(
                right: 19.w,
                top: 19.h,
                child: GestureDetector(
                    onTap: () => _removeOverlay(),
                    child: Image.asset(
                      ImagePath.wtmcross,
                      width: 15.75.w,
                      height: 15.75.h,
                    ))),
            // 내용
            PageView(
              controller: pageController,
              children: [
                // 첫 페이지
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 50.w),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: '\'언제보까\'는 \n',
                            style: TextStyle(
                                decorationThickness: 0,
                                fontFamily: 'NanumSquareNeo',
                                fontSize: 13.sp,
                                height: 2,
                                color: AppColors.White),
                          ),
                          TextSpan(
                            text: '팀원 간 ',
                            style: TextStyle(
                                decorationThickness: 0,
                                fontFamily: 'NanumSquareNeo',
                                fontSize: 13.sp,
                                color: AppColors.White),
                          ),
                          TextSpan(
                            text: '일정을 조율',
                            style: TextStyle(
                                decorationThickness: 0,
                                fontFamily: 'NanumSquareNeo',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.White),
                          ),
                          TextSpan(
                            text: '할 수 있는 기능이에요',
                            style: TextStyle(
                                decorationThickness: 0,
                                fontFamily: 'NanumSquareNeo',
                                fontSize: 13.sp,
                                color: AppColors.White),
                          ),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 47.h),
                      child: Center(
                          child: Image.asset(
                            alignment: Alignment.bottomCenter,
                            ImagePath.wtmtutorial1,
                            width: 296.w,
                            height: 474.h,
                          )),
                    ),
                  ],
                ),
                // 두 번째 페이지
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 50.w),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: '팀원을 언제보까에 초대한 뒤, \n',
                            style: TextStyle(
                                decorationThickness: 0,
                                fontFamily: 'NanumSquareNeo',
                                fontSize: 13.sp,
                                color: AppColors.White),
                          ),
                          TextSpan(
                            text: '서로 가능한 ',
                            style: TextStyle(
                                decorationThickness: 0,
                                fontFamily: 'NanumSquareNeo',
                                fontSize: 13.sp,
                                color: AppColors.White),
                          ),
                          TextSpan(
                            text: '시간대를 선택',
                            style: TextStyle(
                                decorationThickness: 0,
                                fontFamily: 'NanumSquareNeo',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.White),
                          ),
                          TextSpan(
                            text: '하고 \n',
                            style: TextStyle(
                                decorationThickness: 0,
                                fontFamily: 'NanumSquareNeo',
                                fontSize: 13.sp,
                                color: AppColors.White),
                          ),
                          TextSpan(
                            text: '일정을 비교',
                            style: TextStyle(
                                decorationThickness: 0,
                                fontFamily: 'NanumSquareNeo',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.White),
                          ),
                          TextSpan(
                            text: '해보세요!',
                            style: TextStyle(
                                decorationThickness: 0,
                                fontFamily: 'NanumSquareNeo',
                                fontSize: 13.sp,
                                color: AppColors.White),
                          ),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.h),
                      child: Center(
                          child: Image.asset(
                            alignment: Alignment.bottomCenter,
                            ImagePath.wtmtutorial2,
                            width: 296.w,
                            height: 444.h,
                          )),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 219.h,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: 2,
                  effect: WormEffect(
                    dotColor: AppColors.G_03,
                    activeDotColor: AppColors.White,
                    dotHeight: 7.h,
                    dotWidth: 7.w,
                  ),
                  // 효과
                  onDotClicked: (index) {
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      )),
    );

    Overlay.of(context).insert(_overlayEntry.value!);
  }

  void _removeOverlay() {
    _overlayEntry.value?.remove();
    _overlayEntry.value = null;
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
