import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../../data/color_data.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime dt) onChangeListener;
  final DateTime start;
  final DateTime end;
  final DateTime init;

  const CustomDatePicker(
      {super.key,
      required this.start,
      required this.end,
      required this.init,
      required this.onChangeListener});

  @override
  State<StatefulWidget> createState() {
    return _CustomDatePickerState();
  }
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final Rx<DateTime> _current = DateTime.now().obs;

  @override
  void initState() {
    _current.value = widget.init;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: _CustomPicker(
            getYearList(),
            widget.init.year - widget.start.year,
            (int v) {
              DateTime updatedDate = DateTime(
                widget.start.year + v,
                _current.value.month,
                min(
                    _current.value.day,
                    DateTime(widget.start.year + v, _current.value.month + 1, 0)
                        .day),
              );
              _updateCurrentDate(updatedDate);
            },
          ),
        ),
        Flexible(
          child: _CustomPicker(
            getMonthList(),
            widget.init.month - 1,
            (int v) {
              DateTime updatedDate = DateTime(
                _current.value.year,
                v + 1,
                min(_current.value.day,
                    DateTime(_current.value.year, v + 2, 0).day),
              );
              _updateCurrentDate(updatedDate);
            },
          ),
        ),
        Flexible(
          child: Obx(
            () => _CustomPicker(
              getDayList(),
              widget.init.day - 1,
              (int v) {
                _updateCurrentDate(_current.value.copyWith(day: v + 1));
              },
            ),
          ),
        ),
      ],
    );
  }

  void _updateCurrentDate(DateTime date) {
    setState(() {
      _current.value = date;
      widget.onChangeListener.call(_current.value);
    });
  }

  List<String> getYearList() {
    return List<String>.generate(widget.end.year - widget.start.year + 1,
        (index) => '${widget.start.year + index}');
  }

  List<String> getMonthList() {
    return List<String>.generate(
        12, (index) => (index + 1).toString().padLeft(2, '0'));
  }

  List<String> getDayList() {
    DateTime nextMonth =
        DateTime(_current.value.year, _current.value.month + 1, 0);
    int length = nextMonth.day;
    return List<String>.generate(
        length, (index) => (index + 1).toString().padLeft(2, '0'));
  }
}

class _CustomPicker extends StatelessWidget {
  late final FixedExtentScrollController? scrollController;
  final List<String> items;
  final Function(int value) onChanged;

  _CustomPicker(this.items, int init, this.onChanged) {
    scrollController = FixedExtentScrollController(initialItem: init);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60.h,
        child: CupertinoPicker.builder(
          backgroundColor: Colors.transparent,
          selectionOverlay: const SizedBox(),
          itemExtent: 25.h,
          scrollController: scrollController,
          onSelectedItemChanged: onChanged,
          childCount: items.length,
          itemBuilder: (context, index) {
            // AutoSizeText 사용, presetFontSizes로 고정 폰트 크기 목록 제공
            return AutoSizeText(
              items[index],
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.Black,
                fontFamily: 'NanumSquareNeo',
                fontWeight: FontWeight.bold,
                height: 0,
              ),
              presetFontSizes: [13.sp], // 고정 폰트 크기 목록. 이 예제에서는 16.sp를 사용
              textAlign: TextAlign.center, // 텍스트를 중앙 정렬
            );
          },
        ));
  }
}
