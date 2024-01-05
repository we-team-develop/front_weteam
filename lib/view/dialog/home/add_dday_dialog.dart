import 'package:flutter/material.dart';
import 'package:front_weteam/view/dialog/custom_big_dialog.dart';
import 'package:front_weteam/view/widget/custom_text_field.dart';
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
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 185,
                height: 25.60,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: const Color(0xFFE2583E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}