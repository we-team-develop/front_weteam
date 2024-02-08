import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/color_data.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime dt) onChangeListener;

  final DateTime start;
  final DateTime end;
  final DateTime init;

  const CustomDatePicker({super.key, required this.start, required this.end, required this.init, required this.onChangeListener});

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
            child: _CustomPicker(getYearList(), widget.init.year - widget.start.year, (int v) {
              _current.value = _current.value.copyWith(year: widget.start.year + v);
              _current.value.printInfo();
              widget.onChangeListener.call(_current.value);
            }
            )),
        Flexible(
            child: _CustomPicker(getMonthList(), widget.init.month - 1, (int v) {
              _current.value = _current.value.copyWith(month: v + 1);
              _current.value.printInfo();
              widget.onChangeListener.call(_current.value);
            })),
        Flexible(
            child: Obx(
                  () => _CustomPicker(getDayList(), widget.init.day - 1, (int v) {
                _current.value = _current.value.copyWith(day: v + 1);
                _current.value.printInfo();
                widget.onChangeListener.call(_current.value);
              }),
            ))
      ],
    );
  }

  List<String> getYearList() {
    return List<String>.generate(
        widget.end.year - widget.start.year + 1,
            (index) => '${widget.start.year + index}');
  }
  List<String> getMonthList() {
    return List<String>.generate(
        12, (index) => (index + 1).toString().padLeft(2, '0'));
  }

  List<String> getDayList() {
    int length = _current.value.copyWith(day: 0).day;
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
          selectionOverlay: Container(),
          itemExtent: 25.h,
          scrollController: scrollController,
          onSelectedItemChanged: onChanged,
          childCount: items.length,
          itemBuilder: (context, index) {
            return Text(items[index],
                style: TextStyle(
                  color: AppColors.Black,
                  fontSize: 15.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ));
          },
        ));
  }
}