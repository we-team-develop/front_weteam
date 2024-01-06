import 'package:flutter/material.dart';
import 'package:front_weteam/view/dialog/custom_big_dialog.dart';
import 'package:front_weteam/view/widget/custom_text_field.dart';
import 'package:front_weteam/view/widget/normal_button.dart';
import 'package:get/get.dart';

class AddDDayDialog extends StatefulWidget {
  const AddDDayDialog({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddDDayDialogState();
  }
}

class _AddDDayDialogState extends State<AddDDayDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomBigDialog(title: '디데이 추가',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(hint: '디데이명', maxLength: 20),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                DateText()
              ],
            ),
            const SizedBox(
              height: 13,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                DateText()
              ],
            ),
            const SizedBox(height: 22,),
            NormalButton(text: '확인', onTap: () => Get.back()),
          ],
        ));
  }
}