import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/home_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/view/dialog/home/add_dday_dialog.dart';
import 'package:front_weteam/view/dialog/home/add_team_dialog.dart';
import 'package:front_weteam/view/dialog/home/check_remove_dday_dialog.dart';
import 'package:front_weteam/view/widget/app_title_widget.dart';
import 'package:front_weteam/view/widget/normal_button.dart';
import 'package:front_weteam/view/widget/team_project_column.dart';
import 'package:get/get.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 0), child: _body());
  }

  Widget _body() {
    return Column(
      children: [
        _head(),
        SizedBox(
          height: 12.h,
        ),
        Expanded(child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Obx(() => DDayWidget(dDayData: controller.dDayData.value)),
                  _getTeamProjectListBody(),
                  _bottomBanner(),
                  SizedBox(height: 15.h)
                ],
              ),
            )
          ],
        ))
      ],
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
    return Image.asset(
            width: 24.65.w,
            height: 22.99.h,
            controller.hasNewNotification()
                ? ImagePath.icBellNew
                : ImagePath.icBell);
  }

  Widget _getTeamProjectListBody() {
    if (controller.isTeamListEmpty()) {
      // 팀플 없으면
      return _noTeamProjectWidget();
    }

    return Expanded(
        child: Column(
      children: [
        // Divider
        SizedBox(height: 15.h),
        const SizedBox(
          height: 0.7,
          width: double.infinity,
          child: ColoredBox(
            color: Color(0xFFD9D9D9),
          ),
        ),
        SizedBox(height: 15.h),

        // 팀플 목록
        Expanded(child: TeamProjectColumn(getTeamListExample())),

        // 팀플 추가하기 버튼
        SizedBox(height: 16.h),
        _addTeamProjectBigButton(),
        SizedBox(height: 16.h),
      ],
    ));
  }

  Widget _addTeamProjectBigButton() {
    return GestureDetector(
      onTap: () => controller.popupDialog(const DDayDialog()),
      child: Container(
        width: 330.w,
        height: 49.h,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(8),
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
                color: const Color(0xFF333333),
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
    return Expanded(
        child: SizedBox(
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
                        controller.popupDialog(const AddTeamDialog());
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
                      '진행 중인  팀플이 없어요.\n지금 바로 생성해보세요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF333333),
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
                right: 10,
                bottom: 0,
                child: Image.asset(
                  ImagePath.icEmptyTimi,
                  width: 75.55.w,
                  height: 96.h,
                ),
              )
            ],
          ),
        ));
  }

  List<TeamProject> getTeamListExample() {
     return [
      const TeamProject(
          img: "",
          title: '모션그래픽기획및제작',
          description: '기말 팀 영상 제작',
          memberSize: 4,
          date: '2023.10.05~ 2024.12.08'),
      const TeamProject(
          img: "",
          title: '실감미디어콘텐츠개발',
          description: '기말 팀 프로젝트 : Unity AR룰러앱 제작',
          memberSize: 4,
          date: '2023.10.05~ 2024.12.19'),
      const TeamProject(
          img: "",
          title: '머신러닝의이해와실제',
          description: '머신러닝 활용 프로그램 제작 프로젝트',
          memberSize: 2,
          date: '2023.11.28~ 2024.12.08'),
      const TeamProject(
          img: "",
          title: '빽스타2기',
          description: '빽다방서포터즈 팀작업',
          memberSize: 4,
          date: '2023.07.01~ 2024.10.01'),
    ];
  }

  Widget _bottomBanner() {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: ShapeDecoration(
        color: const Color(0xFFFFF1EF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
  DDayData? dday;
  String leftDays = "";

  @override
  Widget build(BuildContext context) {
    if (widget.dDayData != null) {
      dday = widget.dDayData;
      updateLeftDays();
      return _ddayWidget();
    } else {
      return _noDDayWidget();
    }
  }

  void updateLeftDays() {
    assert(dday != null);

    String tmp = "D";
    String numStr = "";
    DateTime now = DateTime.now().copyWith(hour: 0, minute: 0,second: 0, microsecond: 0, millisecond: 0);

    int diffDays = dday!.end.difference(now).inDays;
    bool hasMoreDays = diffDays > 0;
    if (diffDays < 0) diffDays *= -1; // 절댓값

    numStr = diffDays.toString().padLeft(3, '0');
    if (hasMoreDays) {
      tmp += " - $numStr";
    } else if (diffDays == 0) {
      tmp += "-DAY";
    } else {
      tmp += " + $numStr";
    }

    setState(() {
      leftDays = tmp;
    });
  }

  Widget _ddayWidget() {
    return Container(
        width: 330.w,
        height: 176.h,
        decoration: ShapeDecoration(
          color: const Color(0xFFE2583E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showPopupMenu = !showPopupMenu; // 활성화 상태 반전
                          });
                        },
                        child: ImageData(path: ImagePath.icKebabWhite),
                      ),
                      Visibility(
                        visible: showPopupMenu,
                        child: Container(
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
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
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
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
                                            builder:
                                                (BuildContext context) {
                                              return DDayDialog(dDayData: Get.find<HomeController>().dDayData.value); // TODO: D-Day 수정 Dialog 만들기
                                            });
                                      },
                                      child: SizedBox(
                                        height: 21.h,
                                        child: Center(
                                          child: Text(
                                            '수정하기',
                                            style: TextStyle(
                                              color: const Color(0xFF333333),
                                              fontSize: 8.sp,
                                              fontFamily:
                                              'NanumSquareNeo',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Container(
                                    width: 67.w,
                                    height: 0.50.h,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFEEEEEE)),
                                  ),
                                  GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      // 여백 터치 안 되는 문제 수정
                                      onTap: () {
                                        setState(() {
                                          showPopupMenu = false;
                                          showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext context) {
                                                return const CheckRemoveDdayDialog();
                                              });
                                        });
                                      },
                                      child: SizedBox(
                                          height: 21.h,
                                          child: Center(
                                            child: Text(
                                              '삭제하기',
                                              style: TextStyle(
                                                color: const Color(0xFFE60000),
                                                fontSize: 8.sp,
                                                fontFamily:
                                                'NanumSquareNeo',
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
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        ImagePath.icPinWhite,
                        height: 10.h,
                        width: 10.w,
                      ),
                      Text(
                        "${dday?.name} ",
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
              )
            ],
          ),
        ));
  }

  Widget _noDDayWidget() {
    return Container(
      width: 330.w,
      height: 176.h,
      decoration: ShapeDecoration(
        color: const Color(0xFFFFF2EF),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: const Color(0xFFE4E4E4)),
          borderRadius: BorderRadius.circular(16),
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
                      color: const Color(0xFF333333),
                      fontSize: 11.sp,
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: '추가',
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 11.sp,
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: '해보세요!\n언제든 수정가능합니다:)',
                    style: TextStyle(
                      color: const Color(0xFF333333),
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
            NormalButton(text: '중요 일정 추가하기', onTap: () => Get.find<HomeController>().popupDialog(const DDayDialog())),
          ],
        ),
      ),
    );
  }
}