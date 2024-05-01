import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/app_colors.dart';

class CustomSwitch extends StatefulWidget {
  final Function(bool value) onChanged;
  final bool value;
  final double trackWidth;
  final double trackHeight;
  final double toggleWidth;
  final double toggleHeight;
  final Color toggleActiveColor;
  final Color trackInActiveColor;
  final Color trackActiveColor;
  const CustomSwitch({
    super.key,
    required this.onChanged,
    required this.value,
    this.trackHeight = 25,
    this.trackWidth = 44,
    this.toggleWidth = 21,
    this.toggleHeight = 21,
    this.trackActiveColor = AppColors.orange3,
    this.trackInActiveColor = const Color(0xffcccccc),
    this.toggleActiveColor = AppColors.white,
  });
  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSwitched = !_isSwitched;
        });
      },
      child: SizedBox(
        width: widget.trackWidth.w,
        height: widget.trackHeight.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.trackWidth.w,
              height: widget.trackHeight.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.5.r),
                color: _isSwitched
                    ? widget.trackActiveColor
                    : widget.trackInActiveColor,
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
              top: 2.h,
              bottom: 2.h,
              left: _isSwitched
                  ? widget.trackWidth.w - widget.toggleWidth.w - 2.w
                  : 4.w, // 왼쪽 여백
              right: _isSwitched
                  ? 4.w
                  : widget.trackWidth.w - widget.toggleWidth.w - 2.w, // 오른쪽 여백
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    double newPosition = details.localPosition.dx;

                    _isSwitched = newPosition > 0.0;
                  });
                },
                child: Container(
                  width: widget.toggleWidth.w,
                  height: widget.toggleHeight.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.toggleActiveColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
