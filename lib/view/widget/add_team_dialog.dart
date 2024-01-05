import 'package:flutter/material.dart';
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
    return AlertDialog(
      backgroundColor: const Color(0xFFFFFFFF),
      surfaceTintColor: const Color(0xFFFFFFFF),
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //Dialog Main Title
      title: const Text(
        '팀플 추가',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 12,
          fontFamily: 'NanumSquareNeo',
          fontWeight: FontWeight.w800,
        ),
      ),
      //
      content: Column(
        mainAxisSize: MainAxisSize.min, // 이거 없으면 dialog가 엄청 길어요
        crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
        children: <Widget>[
          _projectNameInputTextField(),
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
              _dateText()
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
              _dateText()
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
      ),
    );
  }

  Widget _dateText() {
    return Text(
      '____년   __월 __일',
      style: TextStyle(
        color: Colors.black.withOpacity(0.5),
        fontSize: 12,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _projectNameInputTextField() {
    return TextField(
      decoration: InputDecoration(
        // 기본 제공 카운터 제거
          counterText: "",
          suffix: Text( // TextField 오른쪽에 counter
            "${titleValue.length} / $maxTitleLength",
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 10,
              fontFamily: 'NanumSquareNeo',
              fontWeight: FontWeight.w400,
              height: 0.26,
            ),
          ),

          // hint 설정
          hintText: " 프로젝트명",
          hintStyle: TextStyle(
            fontFamily: "NanumSquareNeo",
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black.withOpacity(0.3),
          ),

          // 각종 색 변경
          focusColor: const Color(0xFFE2583E),
          fillColor: const Color(0xFFE2583E),
          prefixIconColor: const Color(0xFFE2583E),
          suffixIconColor: const Color(0xFFE2583E),
          hoverColor: const Color(0xFFE2583E),
          iconColor: const Color(0xFFE2583E),

          // hint와 underline 사이의 공간 제거
          contentPadding: const EdgeInsets.all(0),
          isDense: true,

          // Underline의 색을 변경합니다
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE2583E)),
          )),
      cursorColor: const Color(0xFFE2583E), // 깜빡이는 커서의 색 변경
      maxLength: maxTitleLength, // 최대 20자

      onChanged: (newV) {
        setState(() {
          titleValue = newV;
        });
      },
    );
  }
}
