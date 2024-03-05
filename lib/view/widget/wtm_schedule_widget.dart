import 'dart:async';
import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/wtm/wtm_schedule_controller.dart';
import '../../data/color_data.dart';
import '../../model/wtm_project.dart';
import '../../util/weteam_utils.dart';

class WTMSchedule extends StatefulWidget {
  static const List<String> _dateName = ['월', '화', '수', '목', '금', '토', '일'];
  final WTMProject wtm;
  final bool selectionMode;

  const WTMSchedule(this.wtm, this.selectionMode, {super.key});

  @override
  State<WTMSchedule> createState() => _WTMScheduleState();
}

class _WTMScheduleState extends State<WTMSchedule> {
  final ScrollController dateTextHorizontalScrollController = ScrollController();

  final ScrollController calendarHorizontalScrollController = ScrollController();

  final Rx<double> verticalScrollOffset = 0.0.obs;

  final Rx<double> horizontalScrollOffset = 0.0.obs;

  @override
  void initState() {
    super.initState();
    calendarHorizontalScrollController.addListener(() {
      if (horizontalScrollOffset.value != calendarHorizontalScrollController.offset) {
        horizontalScrollOffset.value = calendarHorizontalScrollController.offset;
      }
    });

    dateTextHorizontalScrollController.addListener(() {
      if (horizontalScrollOffset.value != dateTextHorizontalScrollController.offset) {
        horizontalScrollOffset.value = dateTextHorizontalScrollController.offset;
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
            Expanded(child: SizedBox(
                height: 21.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: dateTextHorizontalScrollController,
                  itemCount: widget.wtm.endedAt.difference(widget.wtm.startedAt).inDays + 1,
                  itemBuilder: (_, i) =>
                      _dayText(widget.wtm.startedAt.add(Duration(days: i))),
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
                      controller: calendarHorizontalScrollController,
                      itemCount: widget.wtm.endedAt.difference(widget.wtm.startedAt).inDays + 1,
                      itemBuilder: (_, i) =>
                          _day(context, widget.wtm.startedAt.add(Duration(days: i))),
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
        '${WTMSchedule._dateName[date.weekday - 1]}\n${date.day}',
        style: TextStyle(
            fontFamily: 'NanumGothic',
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            height: 0),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _day(BuildContext c, DateTime date) {
    late StreamSubscription listener;
    ScrollController sc = ScrollController(
        initialScrollOffset: verticalScrollOffset.value,
        onDetach: (p) => listener.cancel());

    sc.addListener(() { // 스크롤이 변경되었을 때
      if (sc.offset == verticalScrollOffset.value) return;
      verticalScrollOffset.value = sc.offset;
    });

    listener = verticalScrollOffset.listen((p0) { // offset값이 변경되었을 때
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

  const _HourSelectBox({required this.parentDt, required this.dt, required this.selectionMode});

  @override
  State<_HourSelectBox> createState() => _HourSelectBoxState();
}

class _HourSelectBoxState extends State<_HourSelectBox> {
  final WTMScheduleController controller = Get.find<WTMScheduleController>();

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
          }
        },
        child: Obx(() {
          late Color color;

          if (widget.selectionMode) {
            String sMapKey = WeteamUtils.formatDateTime(widget.parentDt);
            bool selected =
                controller.selected[sMapKey]?.contains(widget.dt.hour) == true;

            color = selected ? AppColors.Blue_07 : AppColors.G_02;
          } else {
            String pMapKey = WeteamUtils.formatDateTime(widget.dt, withTime: true);
            int population = controller.populationMap[pMapKey] ?? 0;

            if (population == 0) {
              color = AppColors.G_02;
            } else {
              double percent = population / controller.maxPopulation.value;

              if (percent >= 0.75) {
                color = AppColors.Blue_07;
              } else if (percent >= 0.5) {
                color = AppColors.Blue_06;
              } else if (percent >= 0.25) {
                color = AppColors.Blue_05;
              } else {
                color = AppColors.Blue_04;
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
}

class _HourTextList extends StatefulWidget {
  final Rx<double> verticalScrollOffset;

  const _HourTextList({super.key, required this.verticalScrollOffset});
  @override
  State<_HourTextList> createState() => _HourTextListState();
}

class _HourTextListState extends State<_HourTextList> {
  late final ScrollController sc;

  @override
  void initState() {
    super.initState();
    late StreamSubscription listener;

    sc = ScrollController(
        onDetach: (p) => listener.cancel());

    sc.addListener(() { // 스크롤이 변경되었을 때
      if (sc.offset == widget.verticalScrollOffset.value) return;
      widget.verticalScrollOffset.value = sc.offset;
    });

    listener = widget.verticalScrollOffset.listen((p0) { // offset값이 변경되었을 때
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
        }
    );
  }
}
