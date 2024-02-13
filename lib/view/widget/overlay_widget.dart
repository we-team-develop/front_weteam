import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/wtm_controller.dart';
import 'package:front_weteam/data/color_data.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialOverlay extends WTMController {
  final Rx<OverlayEntry?> _overlayEntry = Rx<OverlayEntry?>(null);
  final PageController pageController = PageController();

  void tutorialOverlay(BuildContext context) {
    _overlayEntry.value = OverlayEntry(
      builder: (context) => SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 배경
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(dismissible: true, color: Colors.black),
            ),
            // 내용
            PageView(
              controller: pageController,
              children: [
                // 첫 페이지
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 닫기 버튼
                    GestureDetector(
                      onTap: () => _removeOverlay(),
                      child: Padding(
                        padding: EdgeInsets.only(right: 19.w, bottom: 76.h),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            ImagePath.wtmcross,
                            width: 15.75.w,
                            height: 15.75.h,
                          ),
                        ),
                      ),
                    ),
                    // 텍스트
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 닫기 버튼
                    GestureDetector(
                      onTap: () => _removeOverlay(),
                      child: Padding(
                        padding: EdgeInsets.only(right: 19.w, bottom: 76.h),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            ImagePath.wtmcross,
                            width: 15.75.w,
                            height: 15.75.h,
                          ),
                        ),
                      ),
                    ),
                    // 텍스트
                    Padding(
                      padding: EdgeInsets.only(
                        left: 50.w,
                      ),
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
                      padding: EdgeInsets.only(top: 10.h, left: 223.w),
                      child: GestureDetector(
                        onTap: () => toggleShouldShowOverlay(),
                        child: Row(
                          children: [
                            Obx(() => Image.asset(
                                shouldShowOverlay.isTrue
                                    ? ImagePath.checktutorialfalse
                                    : ImagePath.checktutorialtrue,
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
                                  color: AppColors.White),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Center(
                          child: Image.asset(
                        alignment: Alignment.bottomCenter,
                        ImagePath.wtmtutorial2,
                        width: 296.w,
                        height: 474.h,
                      )),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 494.h,
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
      ),
    );

    Overlay.of(context).insert(_overlayEntry.value!);
  }

  void _removeOverlay() {
    _overlayEntry.value?.remove();
    _overlayEntry.value = null;
  }
}
