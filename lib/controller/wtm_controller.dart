import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/model/weteam_user.dart';
import 'package:front_weteam/service/api_service.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../data/color_data.dart';
import '../data/image_data.dart';
import '../util/weteam_utils.dart';

class WTMController extends GetxController {
  final Rx<OverlayEntry?> _overlayEntry = Rx<OverlayEntry?>(null);
  final Rx<String> searchText = Rx("");
  String? searchWait;

  final Rxn<GetWTMProjectListResult> wtmList = Rxn<GetWTMProjectListResult>();
  final Rxn<TeamProject> selectedTeamProject = Rxn();
  final RxList<TeamProject> tpList = RxList();
  RxString selectedTpList = '진행중인 팀플'.obs;

  // 웬투밋 관련 페이지가 모두 닫혔을 때 호출됩니다.
  @override
  void onClose() {
    super.onClose();
    _removeOverlay(); // 튜토리얼 오버레이를 닫습니다.
  }

  void setSelectedTpList(String tpList) {
    selectedTpList.value = tpList;
    bool done = tpList == "완료된 팀플";
    updateTeamProject(done);
    selectedTeamProject.value = null;
    selectedTeamProject.refresh();
  }

  Future<void> updateTeamProject(bool done) async {
    WeteamUser user = Get.find<AuthService>().user.value!;
    tpList.clear();
    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(0, done, 'DESC', 'DONE', user.id);

    if (result != null) {
      tpList.addAll(result.projectList);
    } else {
      WeteamUtils.snackbar('문제가 발생했습니다', '팀플 목록을 불러오지 못했습니다');
    }
  }

  // WTM MAIN
  void scheduleSearch(String query) {
    query = query.trim();
    searchWait = query;
    // 600ms 대기
    Timer(const Duration(milliseconds: 400), () {
      // 만약 검색어가 바뀌었다면 취소
      if (searchWait != query) return;
      searchText.value = query;
    });
  }

  void showOverlay(BuildContext context) {
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
}
