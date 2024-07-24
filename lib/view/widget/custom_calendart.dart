import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/instance_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../controller/custom_calendar_controller.dart';
import '../../data/app_colors.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final CustomCalendarController controller =
      Get.find<CustomCalendarController>();

  late PagingController<int, _CalendarItem> _pagingController;

  DateTime initDate = DateTime.now().copyWith(
      day: 0, hour: 0, second: 0, minute: 0, microsecond: 0, millisecond: 0);

  @override
  void initState() {
    super.initState();
    int key = controller.now.month - 1;
    _pagingController = PagingController(firstPageKey: key);
    _pagingController.addPageRequestListener((pageKey) async {
      DateTime nextDt =
          DateTime(initDate.year + (pageKey ~/ 12), pageKey % 12 + 1);
      _pagingController.appendPage([_CalendarItem(nextDt)], ++key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, _CalendarItem>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<_CalendarItem>(
        itemBuilder: (context, item, index) => item,
        noItemsFoundIndicatorBuilder: (context) => const Center(),
      ),
    );
  }
}

class _CalendarItem extends StatelessWidget {
  final DateTime date;
  List<_CustomRow> rows = [];

  _CalendarItem(this.date) {
    List<String> str = ['일', '월', '화', '수', '목', '금', '토'];
    rows.add(_CustomRow(List.generate(
        str.length,
        (index) => Center(
                child: Text(
              str[index],
              style: TextStyle(
                  color: AppColors.g4,
                  fontFamily: 'NanumGothic',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold),
            )))));

    List<int> weeks = [7, 1, 2, 3, 4, 5, 6];
    int endDay = date.month < 12
        ? DateTime(date.year, date.month + 1, 0).day
        : DateTime(date.year + 1, 1, 0).day;
    int currentDay = 1;
    while (currentDay <= endDay) {
      List<Widget> list = [];
      for (int i = 0; i < 7; i++) {
        DateTime currentDate = date.copyWith(day: currentDay);
        if (currentDay > endDay) {
          list.add(_BlankDay(date.copyWith(day: endDay)));
        } else if (currentDate.weekday != weeks[i]) {
          list.add(_BlankDay(date.copyWith(day: 1)));
        } else {
          list.add(_DayWidget(currentDate));
          currentDay++;
        }
      }
      rows.add(_CustomRow(list));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 15.w),
            Text('${date.year}년 ${date.month}월',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 15.h),
        ...rows
      ],
    );
  }
}

class _CustomRow extends StatelessWidget {
  List<Widget> items;

  _CustomRow(this.items) {
    items = List.generate(
        items.length,
        (index) => Expanded(
                /*flex: 1,*/
                child: Padding(
              padding: EdgeInsets.only(bottom: 13.h),
              child: items[index],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }
}

class _BlankDay extends GetView<CustomCalendarController> {
  final DateTime date;

  const _BlankDay(this.date);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool selectedCompletely = controller.selectedDt1.value != null &&
          controller.selectedDt2.value != null;
      if (!selectedCompletely) {
        return const SizedBox();
      }
      DateTime later = controller.selectedDt1.value!;
      DateTime earlier = controller.selectedDt2.value!;

      if (later.month == earlier.month) {
        return const SizedBox();
      }

      if (later.isBefore(controller.selectedDt2.value!)) {
        later = controller.selectedDt2.value!;
        earlier = controller.selectedDt1.value!;
      }

      if (date.day < 20) {
        // 앞에 있음
        if (earlier.isBefore(date) &&
            (later.isAfter(date) || later.isAtSameMomentAs(date))) {
          return Container(
              height: 26.h,
              decoration: const BoxDecoration(color: AppColors.blue3));
        }
      } else {
        // 뒤에 있음
        if (later.isAfter(date) &&
            (earlier.isBefore(date) || earlier.isAtSameMomentAs(date))) {
          return Container(
              height: 26.h,
              decoration: const BoxDecoration(color: AppColors.blue3));
        }
      }

      return const SizedBox();
    });
  }
}

class _DayWidget extends GetView<CustomCalendarController> {
  final DateTime date;

  const _DayWidget(this.date);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isEnabled = controller.now.isBefore(date);

      late Color textColor;
      if (!isEnabled) {
        textColor = AppColors.g3;
      } else if (date.weekday == 6) {
        textColor = AppColors.blue1;
      } else if (date.weekday == 7) {
        textColor = AppColors.red;
      } else {
        textColor = AppColors.black;
      }

      bool selectedCompletely = controller.selectedDt1.value != null &&
          controller.selectedDt2.value != null;
      bool selected = controller.selectedDt1.value == date ||
          controller.selectedDt2.value == date;
      bool isContained = false;
      if (selectedCompletely) {
        DateTime later = controller.selectedDt1.value!;
        DateTime earlier = controller.selectedDt2.value!;
        if (later.isBefore(controller.selectedDt2.value!)) {
          later = controller.selectedDt2.value!;
          earlier = controller.selectedDt1.value!;
        }

        if (earlier.isBefore(date) && date.isBefore(later)) {
          isContained = true;
        }
      }

      bool amILater = false;
      if (selected) {
        textColor = AppColors.white;
        if (selectedCompletely) {
          if (controller.selectedDt1.value == date) {
            amILater = controller.selectedDt2.value!.isBefore(date);
          } else {
            amILater = controller.selectedDt1.value!.isBefore(date);
          }
        }
      }

      return GestureDetector(
          onTap: () {
            if (!controller.now.isBefore(date)) return;
            if (controller.selectedDt1.value == null) {
              controller.selectedDt1.value = date;
              return;
            } else if (controller.selectedDt1.value == date) {
              return;
            }

            if (controller.selectedDt2.value == null) {
              controller.selectedDt2.value = date;
              return;
            }
            if (controller.selectedDt1.value == date) {
              controller.selectedDt1.value = null;
              return;
            }
            if (controller.selectedDt2.value == date) {
              controller.selectedDt2.value = null;
              return;
            }
            controller.selectedDt1.value = date;
            controller.selectedDt2.value = null;
          },
          behavior: HitTestBehavior.translucent,
          child: SizedBox(
            height: 30.h,
            width: 30.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    child: Visibility(
                        visible: isContained,
                        child: Container(
                            height: 26.h,
                            decoration:
                                const BoxDecoration(color: AppColors.blue3)))),
                Positioned(
                    left: amILater ? 0 : null,
                    right: amILater ? null : 0,
                    child: Visibility(
                        visible: selected && selectedCompletely,
                        child: Container(
                            height: 26.h,
                            width: 20.w,
                            decoration:
                                const BoxDecoration(color: AppColors.blue3)))),
                Visibility(
                    visible: selected,
                    child: Container(
                        width: 30.w,
                        height: 30.h,
                        decoration: const BoxDecoration(
                            color: AppColors.blue1, shape: BoxShape.circle))),
                Text('${date.day}',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 12.sp,
                        fontFamily: 'NanumGothicBold',
                        fontWeight: FontWeight.bold))
              ],
            ),
          ));
    });
  }
}
