import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/view/dialog/custom_big_dialog.dart';
import 'package:front_weteam/view/widget/custom_text_field.dart';
import 'package:front_weteam/view/widget/normal_button.dart';
import 'package:get/get.dart';

import '../../widget/custom_date_picker.dart';

class AddDDayDialog extends StatefulWidget {
  const AddDDayDialog({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddDDayDialogState();
  }
}

class _AddDDayDialogState extends State<AddDDayDialog> {
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CustomBigDialog(
        title: '디데이 추가',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(hint: '디데이명', maxLength: 20),
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
                            fontSize: 12,
                            fontFamily: 'NanumSquareNeo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        CustomDatePicker(
                            start: DateTime(1980, 1, 1),
                            end: DateTime(2090, 12, 31),
                            init: DateTime.now(),
                            onChangeListener: (v) {
                              startTime = v;
                            }),
                      ],
                    )),
                    Container(
                      width: 1,
                      height: 20.h,
                      margin: EdgeInsets.symmetric(horizontal: 21.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCDCDC),
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
                            fontSize: 12,
                            fontFamily: 'NanumSquareNeo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        CustomDatePicker(
                            start: DateTime(1980, 1, 1),
                            end: DateTime(2090, 12, 31),
                            init: DateTime.now(),
                            onChangeListener: (v) {
                              endTime = v;
                            }),
                      ],
                    ))
                  ],
                )),
            SizedBox(
              height: 30.h,
            ),
            NormalButton(text: '확인', onTap: () => onTapButton()),
          ],
        ));
  }

  void onTapButton() {
    Get.back();
  }
}
