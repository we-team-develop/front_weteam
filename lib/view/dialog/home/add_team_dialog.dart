import 'package:flutter/material.dart';
import 'package:front_weteam/view/dialog/custom_big_dialog.dart';
import 'package:front_weteam/view/widget/custom_text_field.dart';
import 'package:front_weteam/view/widget/normal_button.dart';
import 'package:get/get.dart';

class AddTeamDialog extends StatefulWidget {
  const AddTeamDialog({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddTeamDialog();
  }
}

class _AddTeamDialog extends State<AddTeamDialog> {
  final maxTitleLength = 20;
  String titleValue = "";

  @override
  Widget build(BuildContext context) {
    return CustomBigDialog(title: '팀플 추가', child: _body());
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.min, // 이거 없으면 dialog가 엄청 길어요
      crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
      children: <Widget>[
        CustomTextField(hint: "프로젝트명", maxLength: 20,),
        const SizedBox(
          height: 12,
        ),
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
        const SizedBox(
          height: 13,
        ),
        Row(
          // 상세내용이 왼쪽 정렬
          children: [
            Text(
              '상세내용',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 12,
                fontFamily: 'NanumSquareNeo',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 76, minWidth: 260),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    side:
                    const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  // 여백 제거
                  contentPadding: EdgeInsets.all(0),
                  isDense: true,
                ),
                cursorColor: Color(0xFFE2583E), // 깜빡이는 커서의 색 변경
                style: TextStyle(fontSize: 13),
              ),
            )),
        const SizedBox(
          height: 28,
        ),
        NormalButton(text: '확인', onTap: () => Get.back()),
      ],
    );
  }
}
