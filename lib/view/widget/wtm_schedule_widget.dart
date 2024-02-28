import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/wtm/wtm_schedule_controller.dart';
import '../../data/color_data.dart';
import '../../model/wtm_project.dart';
import '../../util/weteam_utils.dart';

class WTMSchedule extends GetView<WTMScheduleController> {
  final WTMProject wtm;
  final bool selectionMode;

  WTMSchedule(this.wtm, this.selectionMode, {super.key}) {
    Get.put(WTMScheduleController());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) {
        //details.scale
      },
      child: Row(
        children: [
          SizedBox(
            width: 33.79.w,
            child: _HourTextColumn(),
          ),
          SizedBox(width: 11.w),
          Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: wtm.endedAt.difference(wtm.startedAt).inDays + 1,
                itemBuilder: (_, i) =>
                    _day(context, wtm.startedAt.add(Duration(days: i))),
              ))
        ],
      ),
    );
  }

  Widget _day(BuildContext c, DateTime date) {
    ScrollController sc =
        ScrollController(initialScrollOffset: controller.verticalScrollOffset.value);
    sc.addListener(() {
      if (sc.offset == controller.verticalScrollOffset.value) return;
      controller.dt = date;
      controller.verticalScrollOffset.value = sc.offset;
    });
    controller.verticalScrollOffset.listen((p0) {
      if (sc.hasClients && controller.dt != date) {
        sc.jumpTo(controller.verticalScrollOffset.value);
      }
    });
    List<String> strDate = ['월', '화', '수', '목', '금', '토', '일'];
    return SizedBox(
      width: (43.29 + 5).w,
      child: ListView(
        controller: sc,
        physics: const ClampingScrollPhysics(),
        children: [
          SizedBox(
            height: 21.h,
            child: AutoSizeText(
              '${strDate[date.weekday - 1]}\n${date.day}',
              style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  height: 0),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 6.h),
          ...List<Widget>.generate(
              24,
              (index) =>
                  _Hour(
                  selectionMode: selectionMode,
                  parentDt: date,
                  dt: DateTime(date.year, date.month, date.day, index)))
        ],
      ),
    );
  }
}

class _Hour extends GetView<WTMScheduleController> {
  final DateTime dt;
  final DateTime parentDt;
  final bool selectionMode;

  const _Hour({required this.parentDt, required this.dt, required this.selectionMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.25.h, right: 5.w),
      child: GestureDetector(
        onTap: () {
          String dtKey = WeteamUtils.formatDateTime(parentDt);
          if (selectionMode) {
            HashSet<int>? set = controller.selected[dtKey];
            set ??= HashSet<int>();

            if (set.contains(dt.hour)) {
             set.remove(dt.hour);
            } else {
              set.add(dt.hour);
            }

            controller.selected[dtKey] = set;
          }
        },
        child: Obx(() {
          late Color color;

          if (selectionMode) {
            String sMapKey = WeteamUtils.formatDateTime(parentDt);
            bool selected =
                controller.selected[sMapKey]?.contains(dt.hour) == true;

            color = selected ? AppColors.Blue_07 : AppColors.G_02;
          } else {
            String pMapKey = WeteamUtils.formatDateTime(dt, withTime: true);
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

class _HourTextColumn extends StatefulWidget {
  @override
  State<_HourTextColumn> createState() => _HourTextColumnState();
}

class _HourTextColumnState extends State<_HourTextColumn> {
  final WTMScheduleController controller = Get.find<WTMScheduleController>();
  final ScrollController sc = ScrollController();

  _HourTextColumnState() {
    sc.addListener(() {
      if (sc.offset == controller.verticalScrollOffset.value) return;
      controller.dt = null;
      controller.verticalScrollOffset.value = sc.offset;
    });
    controller.verticalScrollOffset.listen((p0) {
      if (sc.hasClients && controller.dt != null) {
        sc.jumpTo(controller.verticalScrollOffset.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
          controller: sc,
          itemCount: 25,
          itemBuilder: (context, index) {
            if (index == 0) return SizedBox(height: 28.02.h);
            String hour = ((index - 1) % 25).toString().padLeft(2, '0');
            return Padding(
              padding: EdgeInsets.only(bottom: 3.25.h, right: 5.w),
              child: SizedBox(
                height: 17.38.h,
                child: Text(
                  '$hour:00',
                  style: TextStyle(
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp),
                ),
              ),
            );
          }
        ))
      ],
    );
  }
}
