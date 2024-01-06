import 'package:flutter/material.dart';

class CustomCheckDialog extends StatelessWidget {
  final String title; // 예시: 정말 로그아웃 하시겠습니까?
  final String content; // 예시: 다시 돌아올 거라 믿어요😢
  final String denyName;
  final String admitName;
  final int denyColorInt;
  final int admitColorInt;
  final VoidCallback? denyCallback;
  final VoidCallback? admitCallback;

  const CustomCheckDialog(
      {super.key,
      required this.title,
      required this.content,
      this.denyName = '아니오',
      this.admitName = '네',
      this.denyColorInt = 0xFF333333, // (약) 검정
      this.admitColorInt = 0xFFE60000, // 붉은 색
      this.denyCallback,
      this.admitCallback});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.fromLTRB(40, 28, 40, 5),
      backgroundColor: const Color(0xFFFFFFFF),
      surfaceTintColor: const Color(0xFFFFFFFF),
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //Dialog Main Title
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF333333),
          fontSize: 12,
          fontFamily: 'NanumSquareNeo',
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min, // 최소 크기로
        crossAxisAlignment: CrossAxisAlignment.center, // 가운데 정렬
        children: [
          Text(content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 10,
                fontFamily: 'NanumSquareNeo',
                fontWeight: FontWeight.w400,
              )),

          const SizedBox(height: 12.37),
          // Divider
          Container(
            width: double.infinity,
            height: 0.5,
            decoration: const BoxDecoration(
              color: Color(0xFFDCDCDC),
            ),
          ),
          IntrinsicHeight(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _button(denyName, denyColorInt, denyCallback),
              Container(
                width: 0.5,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCDCDC),
                ),
              ),
              _button(admitName, admitColorInt, admitCallback)
            ],
          )),
        ],
      ),
    );
  }

  Widget _button(String name, int colorInt, VoidCallback? callback) {
    return Expanded(
      child: InkWell(
        onTap: callback ?? () {},
        //behavior: HitTestBehavior.translucent, // 모든 곳 터치 되도록
        child: Center(
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(colorInt),
              fontSize: 12,
              fontFamily: 'NanumSquareNeo',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}
