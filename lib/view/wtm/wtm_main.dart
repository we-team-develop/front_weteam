import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../binding/wtm_bindings.dart';
import '../../controller/wtm_controller.dart';
import '../../data/color_data.dart';
import '../../data/image_data.dart';
import 'wtm_create.dart';

class WTM extends GetView<WTMController> {
  WTM({super.key});

  final overlayKey = GlobalKey();

  final Rx<OverlayEntry?> _overlayEntry = Rx<OverlayEntry?>(null);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOverlay(context);
    });
    return Scaffold(
      key: overlayKey,
      body: Padding(
        padding: EdgeInsets.only(top: 47.0.h),
        child: _body(),
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry.value != null) {
      // 이미 오버레이가 표시되어 있다면 무시
      return;
    }

    final PageController pageController = PageController();

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

  Widget _body() {
    return Center(
      child: Column(
        children: [
          _head(),
          SizedBox(
            height: 153.h,
          ),
          Expanded(
              child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    _wtmbody(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25.h),
                      child: GestureDetector(
                          onTap: () {
                            Get.to(() => WTMCreate(),
                                binding: WTMCreateBinding());
                          },
                          child: _newWTMButton()),
                    ),
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _head() {
    return Center(
      child: Text(
        '언제보까',
        style: TextStyle(
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _wtmbody() {
    return _noWTMWidget();
  }

  Widget _noWTMWidget() {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    ImagePath.wtmEmptyTimi,
                    width: 127.w,
                    height: 131.h,
                  ),
                  Text(
                    '생성된 언제보까가 없어요.\n지금 바로 생성해보세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.Black,
                      fontSize: 11.sp,
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newWTMButton() {
    return Image.asset(
      ImagePath.makewtmbutton,
      width: 330.w,
      height: 49.h,
    );
  }
}
