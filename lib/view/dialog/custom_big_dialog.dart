import 'package:flutter/material.dart';

class CustomBigDialog extends StatelessWidget {
  final String title;
  final Widget child;

  const CustomBigDialog({super.key, this.title = "", required this.child});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
          fontWeight: FontWeight.w800,
        ),
      ),
      content: child,
    );
  }
}

/*class DateText extends StatelessWidget {
  const DateText({super.key});

  @override
  Widget build(BuildContext context) {
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

}*/
