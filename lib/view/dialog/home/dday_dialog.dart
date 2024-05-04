import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/mainpage/home_controller.dart';
import '../../../data/app_colors.dart';
import '../../../main.dart';
import '../../../util/weteam_utils.dart';
import '../../widget/custom_date_picker.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/normal_button.dart';
import '../custom_big_dialog.dart';

class DDayDialog extends StatefulWidget {
  final DDayData? dDayData;
  const DDayDialog({super.key, this.dDayData});

  @override
  State<StatefulWidget> createState() {
    return _DDayDialogState();
  }
}

class _DDayDialogState extends State<DDayDialog> {
  String title = "";
  TextEditingController teController = TextEditingController();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();


  @override
  void initState() {
    if (widget.dDayData != null) {
      title = '디데이 수정';
      teController.text = widget.dDayData!.name;
      startTime = widget.dDayData!.start;
      endTime = widget.dDayData!.end;
    } else { // 디데이 없음
      title = '디데이 추가';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBigDialog(
        title: title,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(hint: '디데이명', maxLength: 20, controller: teController),
            SizedBox(height: 20.h),
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 304.w),
                child: Row(
                  children: [
                    Flexible(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '시작일',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 12.sp,
                            fontFamily: 'NanumSquareNeo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        CustomDatePicker(
                            start: DateTime(1980, 1, 1),
                            end: DateTime(2090, 12, 31),
                            init: startTime,
                            onChangeListener: (v) {
                              startTime = v;
                            }),
                      ],
                    )),
                    Container(
                      width: 1,
                      height: 90.h,
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: const BoxDecoration(
                        color: AppColors.g2,
                      ),
                    ),
                    Flexible(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '종료일',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 12.sp,
                            fontFamily: 'NanumSquareNeo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        CustomDatePicker(
                            start: DateTime(1980, 1, 1),
                            end: DateTime(2090, 12, 31),
                            init: endTime,
                            onChangeListener: (v) {
                              endTime = v;
                            }),
                      ],
                    ))
                  ],
                )),
            SizedBox(
              height: 24.h,
            ),
            NormalButton(
                text: '확인',
                width: 185.w,
                height: 40.h,
                fontSize: 12.sp,
                onTap: () async {
                  try {
                    await onTapButton();
                  } catch (e, st) {
                    debugPrint(e.toString());
                    debugPrintStack(stackTrace: st);
                    WeteamUtils.snackbar('', '오류가 발생하여 불러오지 못했어요', icon: SnackbarIcon.fail);
                  }
                }),
          ],
        ));
  }

  Future<void> onTapButton() async {
    if (endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch < 0) {
      setState(() {
        WeteamUtils.snackbar('', '시작일이 종료일보다 빠를 수 없어요', icon: SnackbarIcon.info);
      });
      return;
    }

    String name = teController.text.trim();
    if (name.isEmpty) {
      setState(() {
        WeteamUtils.snackbar('', '디데이명을 입력해 주세요', icon: SnackbarIcon.info);
      });
      return;
    }

    Map map = {
      'name': name,
      'start': {
        'year': startTime.year,
        'month': startTime.month,
        'day': startTime.day,
      },
      'end': {
        'year': endTime.year,
        'month': endTime.month,
        'day': endTime.day,
      },
    };

    await sharedPreferences.setString(SharedPreferencesKeys.dDayData, jsonEncode(map));
    HomeController hc = Get.find<HomeController>();
    hc.updateDDay();
    Get.find<HomeController>().update();
    Get.back();
  }
}
