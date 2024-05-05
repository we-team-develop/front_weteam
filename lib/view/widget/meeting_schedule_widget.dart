import 'dart:async';
import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/meeting/meeting_current_controller.dart';
import '../../controller/meeting/meeting_schedule_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../../model/weteam_user.dart';
import '../../model/meeting.dart';
import '../../model/meeting_detail.dart';
import '../../util/weteam_utils.dart';

class MeetingSchedule extends StatefulWidget {
  static const List<String> _dateName = ['월', '화', '수', '목', '금', '토', '일'];
  final Meeting meeting;
  final bool selectionMode;

  const MeetingSchedule(this.meeting, this.selectionMode, {super.key});

  @override
  State<MeetingSchedule> createState() => _MeetingScheduleState();
}

class _MeetingScheduleState extends State<MeetingSchedule> {
  final ScrollController dateTextHorizontalScrollController =
      ScrollController();

  final ScrollController calendarHorizontalScrollController =
      ScrollController();

  final Rx<double> verticalScrollOffset = 0.0.obs;

  final Rx<double> horizontalScrollOffset = 0.0.obs;

  @override
  void initState() {
    super.initState();
    calendarHorizontalScrollController.addListener(() {
      if (horizontalScrollOffset.value !=
          calendarHorizontalScrollController.offset) {
        horizontalScrollOffset.value =
            calendarHorizontalScrollController.offset;
      }
    });

    dateTextHorizontalScrollController.addListener(() {
      if (horizontalScrollOffset.value !=
          dateTextHorizontalScrollController.offset) {
        horizontalScrollOffset.value =
            dateTextHorizontalScrollController.offset;
      }
    });

    horizontalScrollOffset.listen((p0) {
      if (p0 != calendarHorizontalScrollController.offset) {
        calendarHorizontalScrollController.jumpTo(p0);
      }
      if (p0 != dateTextHorizontalScrollController.offset) {
        dateTextHorizontalScrollController.jumpTo(p0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 44.79.w),
            Expanded(
                child: SizedBox(
                    height: 21.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      controller: dateTextHorizontalScrollController,
                      itemCount: widget.meeting.endedAt
                              .difference(widget.meeting.startedAt)
                              .inDays +
                          1,
                      itemBuilder: (_, i) => _dayText(
                          widget.meeting.startedAt.add(Duration(days: i))),
                    )))
          ],
        ),
        SizedBox(height: 6.h),
        Expanded(
            child: Row(
          children: [
            SizedBox(
              width: 44.79.w,
              child: _HourTextList(verticalScrollOffset: verticalScrollOffset),
            ),
            Expanded(
                child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              controller: calendarHorizontalScrollController,
              itemCount: widget.meeting.endedAt
                      .difference(widget.meeting.startedAt)
                      .inDays +
                  1,
              itemBuilder: (_, i) => _day(
                  context, widget.meeting.startedAt.add(Duration(days: i))),
            ))
          ],
        ))
      ],
    );
  }

  Widget _dayText(DateTime date) {
    return SizedBox(
      width: (43.29 + 5).w,
      child: AutoSizeText(
        '${MeetingSchedule._dateName[date.weekday - 1]}\n${WeteamUtils.padLeft(date.month)}.${WeteamUtils.padLeft(date.day)}',
        style: TextStyle(
            fontFamily: 'NanumGothic',
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            height: 0),
        minFontSize: 1,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _day(BuildContext c, DateTime date) {
    late StreamSubscription listener;
    ScrollController sc = ScrollController(
        initialScrollOffset: verticalScrollOffset.value,
        onDetach: (p) => listener.cancel());

    sc.addListener(() {
      // 스크롤이 변경되었을 때
      if (sc.offset == verticalScrollOffset.value) return;
      verticalScrollOffset.value = sc.offset;
    });

    listener = verticalScrollOffset.listen((p0) {
      // offset값이 변경되었을 때
      if (sc.offset != p0) {
        sc.jumpTo(p0);
      }
    });

    return SizedBox(
        width: (43.29 + 5).w,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator(); // 오버스크롤 위젯 늘어남 방지
            return true;
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: sc,
            physics: const ClampingScrollPhysics(),
            itemCount: 24,
            itemBuilder: (context, index) => _HourSelectBox(
                selectionMode: widget.selectionMode,
                parentDt: date,
                dt: DateTime(date.year, date.month, date.day, index)),
          ),
        ));
  }
}

class _HourSelectBox extends StatefulWidget {
  final DateTime dt;
  final DateTime parentDt;
  final bool selectionMode;

  const _HourSelectBox(
      {required this.parentDt, required this.dt, required this.selectionMode});

  @override
  State<_HourSelectBox> createState() => _HourSelectBoxState();
}

class _HourSelectBoxState extends State<_HourSelectBox> {
  final MeetingScheduleController controller =
      Get.find<MeetingScheduleController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.25.h, right: 5.w),
      child: GestureDetector(
        onTap: () {
          String dtKey = WeteamUtils.formatDateTime(widget.parentDt);
          if (widget.selectionMode) {
            HashSet<int>? set = controller.selected[dtKey];
            set ??= HashSet<int>();

            if (set.contains(widget.dt.hour)) {
              set.remove(widget.dt.hour);
            } else {
              set.add(widget.dt.hour);
            }

            controller.selected[dtKey] = set;
          } else {
            showBottomSheet();
          }
        },
        child: Obx(() {
          late Color color;

          if (widget.selectionMode) {
            String sMapKey = WeteamUtils.formatDateTime(widget.parentDt);
            bool selected =
                controller.selected[sMapKey]?.contains(widget.dt.hour) == true;

            color = selected ? AppColors.blue7 : AppColors.g2;
          } else {
            List<MeetingUser> pList = _getPopulationList();
            int populationSize = pList.length;

            if (populationSize == 0) {
              color = AppColors.g2;
            } else {
              double percent = populationSize / controller.maxPopulation.value;

              if (percent >= 0.75) {
                color = AppColors.blue7;
              } else if (percent >= 0.5) {
                color = AppColors.blue6;
              } else if (percent >= 0.25) {
                color = AppColors.blue5;
              } else {
                color = AppColors.blue4;
              }
            }
          }

          return Container(
            height: 17.38.h,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(17).r),
          );
        }),
      ),
    );
  }

  List<MeetingUser> _getPopulationList() {
    String pMapKey = WeteamUtils.formatDateTime(widget.dt, withTime: true);
    List<MeetingUser> populationList = controller.populationMap[pMapKey] ?? [];

    return populationList;
  }

  // 여기서 유저 id는 WeteamUser의 ID입니다.
  HashSet<int> _getJoinUserIdSet() {
    List<MeetingUser> pList = _getPopulationList();
    HashSet<int> ret = HashSet();

    for (MeetingUser user in pList) {
      ret.add(user.user.id);
    }

    return ret;
  }

  void showBottomSheet() {
    HashSet<int> joinUserIdSet = _getJoinUserIdSet();
    List<WeteamUser> allJoinUserList =
        Get.find<CurrentMeetingController>().joinedUserList;

    List<String> joinUserNameList = [];
    List<String> notJoinUserNameList = [];

    for (WeteamUser user in allJoinUserList) {
      if (joinUserIdSet.contains(user.id)) {
        // 이 날짜에 참여합니다
        joinUserNameList.add("${user.username}");
      } else {
        // 이 날짜에 참여하지 않습니다
        notJoinUserNameList.add("${user.username}");
      }
    }

    DraggableScrollableController dsController =
        DraggableScrollableController();

    showFlexibleBottomSheet(
      isExpand: true,
      decoration: BoxDecoration(color: Colors.transparent, boxShadow: [
        BoxShadow(color: AppColors.black.withOpacity(0.1), blurRadius: 20)
      ]),
      isDismissible: true,
      bottomSheetColor: Colors.transparent,
      barrierColor: Colors.transparent,
      draggableScrollableController: dsController,
      isSafeArea: false,
      context: context,
      builder: (context, scrollController, bottomSheetOffset) {
        return Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 20,
                    blurRadius: 20,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: ListView(
              controller: scrollController,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.r),
                        color: AppColors.g3),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    Text(
                      '${widget.dt.year}. ${WeteamUtils.padLeft(widget.dt.month)}. ${WeteamUtils.padLeft(widget.dt.day)} ${WeteamUtils.padLeft(widget.dt.hour)}:00',
                      style: TextStyle(
                          fontFamily: "NanumSquareNeo",
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(ImagePath.icCrossClose,
                          width: 25.w, height: 25.h),
                    )
                  ],
                ),
                SizedBox(height: 16.h),
                Container(height: 0.5.h, color: AppColors.g2),
                SizedBox(height: 8.h),
                Text(
                  '참여 가능 : ${joinUserNameList.length}명',
                  style: TextStyle(
                      fontFamily: "NanumSquareNeo",
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp),
                ),
                SizedBox(height: 8.h),
                Visibility(
                  visible: joinUserNameList.isNotEmpty,
                  replacement: Text(
                    '참여 가능한 팀원이 없습니다.',
                    style: TextStyle(
                        fontFamily: 'NanumSquareNeo',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w200),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 12.w,
                    runSpacing: 8.h,
                    children: [
                      for (int i = 0; i < joinUserNameList.length; i++)
                        _UserNameContainer(
                            name: joinUserNameList[i], colored: true)
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  '참여 불가능 : ${notJoinUserNameList.length}명',
                  style: TextStyle(
                      fontFamily: "NanumSquareNeo",
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp),
                ),
                SizedBox(height: 8.h),
                Visibility(
                  visible: notJoinUserNameList.isNotEmpty,
                  replacement: Text(
                    '참여 불가능한 팀원이 없습니다.',
                    style: TextStyle(
                        fontFamily: 'NanumSquareNeo',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w200),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 12.w,
                    runSpacing: 8.h,
                    children: [
                      for (int i = 0; i < notJoinUserNameList.length; i++)
                        _UserNameContainer(
                            name: notJoinUserNameList[i], colored: false)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      anchors: [0, 0.5, 1],
    );
  }
}

class _HourTextList extends StatefulWidget {
  final Rx<double> verticalScrollOffset;

  const _HourTextList({required this.verticalScrollOffset});
  @override
  State<_HourTextList> createState() => _HourTextListState();
}

class _HourTextListState extends State<_HourTextList> {
  late final ScrollController sc;

  @override
  void initState() {
    super.initState();
    late StreamSubscription listener;

    sc = ScrollController(onDetach: (p) => listener.cancel());

    sc.addListener(() {
      // 스크롤이 변경되었을 때
      if (sc.offset == widget.verticalScrollOffset.value) return;
      widget.verticalScrollOffset.value = sc.offset;
    });

    listener = widget.verticalScrollOffset.listen((p0) {
      // offset값이 변경되었을 때
      if (sc.offset != p0) {
        sc.jumpTo(p0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        controller: sc,
        itemCount: 24,
        itemBuilder: (context, index) {
          String hour = index.toString().padLeft(2, '0');

          return Padding(
            padding: EdgeInsets.only(bottom: 3.25.h),
            child: SizedBox(
              height: 17.38.h,
              child: Text(
                '$hour:00',
                style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.bold,
                    color: const Color(0x99000000),
                    fontSize: 10.sp),
              ),
            ),
          );
        });
  }
}

class _UserNameContainer extends StatelessWidget {
  final String name;
  final bool colored;

  const _UserNameContainer({required this.name, required this.colored});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 24.h,
      decoration: BoxDecoration(
          color: colored ? AppColors.orange3 : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 3,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ]),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 9.w),
          child: AutoSizeText(
            name,
            //overflow: TextOverflow.ellipsis,
            minFontSize: 1,
            style: TextStyle(
                fontSize: 10,
                fontFamily: 'NanumGothic',
                color: colored ? AppColors.white : AppColors.black),
          ),
        ),
      ),
    );
  }
}
