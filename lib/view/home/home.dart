import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../binding/meeting_bindings.dart';
import '../../controller/mainpage/home_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../dialog/home/check_remove_dday_dialog.dart';
import '../dialog/home/dday_dialog.dart';
import '../dialog/home/team_project_dialog.dart';
import '../meeting/meeting_main.dart';
import '../widget/app_title_widget.dart';
import '../widget/normal_button.dart';
import 'alarm_list_page.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  StatelessElement createElement() {
    controller.updateTeamProjectList();
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 0), child: _body());
  }

  Widget _body() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.updateTeamProjectList();
      },
      child: Column(
        children: [
          _head(),
          SizedBox(
            height: 12.h,
          ),
          Expanded(child: Obx(() {
            return CustomScrollView(
              controller: controller.scrollController,
              // 항상 스크롤 가능하도록 설정, 안드로이드 스타일 스크롤 방식
              physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics()),
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                      DDayWidget(dDayData: controller.dDayData.value)
                ])),
                if (!(controller.tpWidgetList.value == null ||
                    controller.tpWidgetList.value!.isEmpty))
                  SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: 15.h),
                      const SizedBox(
                        height: 0.7,
                        width: double.infinity,
                        child: ColoredBox(
                          color: AppColors.g2,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      ...controller.tpWidgetList.value ?? [],
                    ]),
                  ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      (controller.tpWidgetList.value == null ||
                              controller.tpWidgetList.value!.isEmpty)
                          ? Expanded(child: _noTeamProjectWidget())
                          : Expanded(
                              child: Column(
                              children: [
                                SizedBox(height: 16.h),
                                // 팀플 추가하기 버튼
                                const Expanded(child: SizedBox()),
                                _addTeamProjectBigButton(),
                                SizedBox(height: 16.h)
                              ],
                            )),
                      GestureDetector(
                          onTap: () {
                            Get.to(() => MeetingMainPage(), binding: MeetingBindings());
                          },
                          child: _bottomBanner()),
                      SizedBox(height: 15.h)
                    ],
                  ),
                ),
              ],
            );
          }))
        ],
      ),
    );
  }

  Widget _head() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [const AppTitleWidget(), _bellIcon()],
    );
  }

  Widget _bellIcon() {
    return Obx(() => GestureDetector(
        onTap: () {
          Get.to(() => const AlarmListPage());
          controller.hasNewAlarm.value = false;
        },
        child: Image.asset(
            width: 24.65.w,
            height: 22.99.h,
            controller.hasNewAlarm.isTrue
                ? ImagePath.icBellNew
                : ImagePath.icBell)));
  }

  Widget _addTeamProjectBigButton() {
    return GestureDetector(
      onTap: () => controller.popupDialog(
          const TeamProjectDialog(mode: TeamProjectDialogMode.add)),
      child: Container(
        width: 330.w,
        height: 49.h,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.r, color: AppColors.g2),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImagePath.icPlusSquareLight,
              width: 21.22.w,
              height: 21.22.h,
            ),
            SizedBox(width: 8.w),
            Text(
              '팀플 추가하기',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 11.sp,
                fontFamily: 'NanumSquareNeo',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _noTeamProjectWidget() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.popupDialog(const TeamProjectDialog(
                        mode: TeamProjectDialogMode.add));
                  },
                  child: Image.asset(
                    ImagePath.icPlus,
                    height: 34.h,
                    width: 34.w,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  '진행 중인 팀플이 없어요.\n지금 바로 생성해보세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 11.sp,
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 10,
            bottom: 0,
            child: Image.asset(
              ImagePath.icEmptyTimi,
              width: 75.55.w,
              height: 96.h,
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomBanner() {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: ShapeDecoration(
        color: AppColors.orange1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      '빠르고 간단하게 팀플 약속잡기!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 8.sp,
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '언제보까? 바로가기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontFamily: 'NanumSquareNeoBold',
                        fontWeight: FontWeight.w900,
                        height: 0,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 16,
            child: Image.asset(
              ImagePath.bottomBannerIcon,
              width: 44.w,
              height: 63.h,
            ),
          )
        ],
      ),
    );
  }
}

class DDayWidget extends StatefulWidget {
  final DDayData? dDayData;

  const DDayWidget({super.key, this.dDayData});

  @override
  State<StatefulWidget> createState() {
    return _DDayWidgetState();
  }
}

class _DDayWidgetState extends State<DDayWidget> {
  bool showPopupMenu = false;
  String leftDays = "";
  StreamSubscription? _subscription;

  @override
  void initState() {
    updateLeftDays();
    super.initState();

    _subscription = Get.find<HomeController>().dDayData.listen((p0) {
      updateLeftDays();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dDayData != null) {
      return _ddayWidget();
    } else {
      return _noDDayWidget();
    }
  }

  void updateLeftDays() {
    if (widget.dDayData == null) return;

    DateTime now = DateTime.now().copyWith(
        hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0);
    int dayDiff = widget.dDayData!.end.difference(now).inDays.abs();
    String numStr = dayDiff.toString().padLeft(3, '0');

    String updatedLeftDays = "";
    if (now.isBefore(widget.dDayData!.end)) {
      updatedLeftDays = "D - $numStr";
    } else if (dayDiff == 0) {
      updatedLeftDays = "D-DAY";
    } else {
      updatedLeftDays = "D + $numStr";
    }

    leftDays = updatedLeftDays;
    setState(() {
    });
  }

  Widget _ddayWidget() {
    return Container(
        width: 330.w,
        height: 176.h,
        decoration: ShapeDecoration(
          color: AppColors.mainOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 13.h, top: 7.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showPopupMenu = !showPopupMenu; // 활성화 상태 반전
                          });
                        },
                        child: Image.asset(ImagePath.icKebabWhite,
                            width: 24.w, height: 24.h),
                      ),
                      Visibility(
                        visible: showPopupMenu,
                        child: Container(
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r)),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x23000000),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      // 여백 터치 안 되는 문제 수정
                                      onTap: () {
                                        setState(() {
                                          showPopupMenu = false;
                                        });
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DDayDialog(
                                                  dDayData: Get.find<
                                                          HomeController>()
                                                      .dDayData
                                                      .value); // TODO: D-Day 수정 Dialog 만들기
                                            });
                                      },
                                      child: SizedBox(
                                        height: 25.h,
                                        child: Center(
                                          child: Text(
                                            '수정하기',
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 8.sp,
                                              fontFamily: 'NanumSquareNeo',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Container(
                                    width: 80.w,
                                    height: 0.50.h,
                                    decoration: const BoxDecoration(
                                        color: AppColors.g2),
                                  ),
                                  GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      // 여백 터치 안 되는 문제 수정
                                      onTap: () {
                                        setState(() {
                                          showPopupMenu = false;
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const CheckRemoveDdayDialog();
                                              });
                                        });
                                      },
                                      child: SizedBox(
                                          height: 25.h,
                                          child: Center(
                                            child: Text(
                                              '삭제하기',
                                              style: TextStyle(
                                                color: AppColors.red,
                                                fontSize: 8.sp,
                                                fontFamily: 'NanumSquareNeo',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ))),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 11.h, left: 19.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          ImagePath.icPinWhite,
                          height: 10.75.h,
                          width: 10.75.w,
                        ),
                        SizedBox(width: 3.62.w),
                        Text(
                          "${widget.dDayData?.name} ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontFamily: 'NanumSquareNeo',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        )
                      ],
                    ),
                    Text(
                      '$leftDays ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 52.sp,
                        fontFamily: 'Cafe24Moyamoya',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  ],
                ))
          ],
        ));
  }

  Widget _noDDayWidget() {
    return Container(
      width: 330.w,
      height: 176.h,
      decoration: ShapeDecoration(
        color: AppColors.orange1,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.r, color: AppColors.g2),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '중요한 일정을 ',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 11.sp,
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: '추가',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 11.sp,
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: '해보세요!\n언제든 수정가능합니다:)',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 11.sp,
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            NormalButton(
                height: 24.h,
                width: 185.w,
                fontSize: 12.sp,
                text: '디데이 추가하기',
                onTap: () =>
                    Get.find<HomeController>().popupDialog(const DDayDialog())),
          ],
        ),
      ),
    );
  }
}
