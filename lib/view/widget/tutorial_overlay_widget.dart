import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controller/meeting/meeting_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';

class TutorialOverlay extends GetView<MeetingController> {
  const TutorialOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 배경
        _background(),
        // 내용
        PageView(
          controller: controller.overlayPageController,
          children: [
            // 첫 페이지
            const _FirstPage(),

            // 두 번째 페이지
            _SecondPage(controller: controller),
          ],
        ),
        Positioned(
          bottom: 454.h,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: controller.overlayPageController,
              count: 2,
              effect: WormEffect(
                dotColor: AppColors.g3,
                activeDotColor: AppColors.white,
                dotHeight: 7.h,
                dotWidth: 7.w,
              ),
              // 효과
              onDotClicked: (index) {
                controller.overlayPageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ),
        // 닫기 버튼
        Positioned(
          top: 44.h,
          right: 0.w,
          child: _closeButton(),
        ),
      ],
    );
  }

  GestureDetector _closeButton() {
    return GestureDetector(
          onTap: () => controller.removeOverlay(),
          child: Padding(
            padding: EdgeInsets.only(right: 19.w, bottom: 76.h),
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                ImagePath.meetingCross,
                width: 15.75.w,
                height: 15.75.h,
              ),
            ),
          ),
        );
  }

  Opacity _background() {
    return const Opacity(
        opacity: 0.6,
        child: ModalBarrier(dismissible: true, color: Colors.black),
      );
  }

}

class _SecondPage extends StatelessWidget {
  const _SecondPage({
    required this.controller,
  });

  final MeetingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 텍스트
              Padding(
                padding: EdgeInsets.only(left: 97.w, top: 105.h),
                child: _text(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.h, left: 223.w),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => controller.toggleShouldShowOverlay(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 15.h, horizontal: 20.w),
                    child: Row(
                      children: [
                        Obx(() => Image.asset(
                            controller.shouldShowOverlay.isTrue
                                ? ImagePath.checkTutorialFalse
                                : ImagePath.checkTutorialTrue,
                            width: 12.w,
                            height: 12.h)),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          '다시 보지 않기',
                          style: TextStyle(
                              decorationThickness: 0,
                              fontFamily: 'NanumSquareNeo',
                              fontSize: 11.sp,
                              color: AppColors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Center(
                    child: _image()),
              ),
            ],
          );
  }

  Image _image() {
    return Image.asset(
      alignment: Alignment.bottomCenter,
      ImagePath.meetingTutorial2,
      width: 296.w,
      height: 474.h,
    );
  }

  Text _text() {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: '팀원을 언제보까에 초대한 뒤, \n',
          style: TextStyle(
              decorationThickness: 0,
              fontFamily: 'NanumSquareNeo',
              height: 2,
              fontSize: 13.sp,
              color: AppColors.white),
        ),
        TextSpan(
          text: '서로 가능한 ',
          style: TextStyle(
              decorationThickness: 0,
              fontFamily: 'NanumSquareNeo',
              fontSize: 13.sp,
              color: AppColors.white),
        ),
        TextSpan(
          text: '시간대를 선택',
          style: TextStyle(
              decorationThickness: 0,
              fontFamily: 'NanumSquareNeo',
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white),
        ),
        TextSpan(
          text: '하고 \n',
          style: TextStyle(
              decorationThickness: 0,
              fontFamily: 'NanumSquareNeo',
              fontSize: 13.sp,
              height: 2,
              color: AppColors.white),
        ),
        TextSpan(
          text: '일정을 비교',
          style: TextStyle(
              decorationThickness: 0,
              fontFamily: 'NanumSquareNeo',
              fontSize: 13.sp,
              height: 2,
              fontWeight: FontWeight.bold,
              color: AppColors.white),
        ),
        TextSpan(
          text: '해보세요!',
          style: TextStyle(
              decorationThickness: 0,
              fontFamily: 'NanumSquareNeo',
              fontSize: 13.sp,
              color: AppColors.white),
        ),
      ]),
      textAlign: TextAlign.center,
    );
  }
}

class _FirstPage extends StatelessWidget {
  const _FirstPage();

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 텍스트
              Padding(
                padding: EdgeInsets.only(left: 66.w, top: 105.h),
                child: _text(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 47.h),
                child: Center(
                    child: _image()),
              ),
            ],
          );
  }

  Image _image() {
    return Image.asset(
                alignment: Alignment.bottomCenter,
                ImagePath.meetingTutorial1,
                width: 296.w,
                height: 474.h,
              );
  }

  Text _text() {
    return Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '\'언제보까\'는 \n',
                      style: TextStyle(
                          decorationThickness: 0,
                          fontFamily: 'NanumSquareNeo',
                          fontSize: 13.sp,
                          height: 2,
                          color: AppColors.white),
                    ),
                    TextSpan(
                      text: '팀원 간 ',
                      style: TextStyle(
                          decorationThickness: 0,
                          fontFamily: 'NanumSquareNeo',
                          fontSize: 13.sp,
                          height: 2,
                          color: AppColors.white),
                    ),
                    TextSpan(
                      text: '일정을 조율',
                      style: TextStyle(
                          decorationThickness: 0,
                          fontFamily: 'NanumSquareNeo',
                          fontSize: 13.sp,
                          color: AppColors.white),
                    ),
                    TextSpan(
                      text: '할 수 있는 기능이에요',
                      style: TextStyle(
                          decorationThickness: 0,
                          fontFamily: 'NanumSquareNeo',
                          fontSize: 13.sp,
                          color: AppColors.white),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              );
  }
}
