import 'package:flutter/material.dart';

class AppTitleWidget extends StatelessWidget {
  const AppTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'WE TEAM',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF333333),
        fontSize: 16,
        fontFamily: 'SBaggroB',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }
}