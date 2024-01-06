import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTitleWidget extends StatelessWidget {
  const AppTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'WE TEAM',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: const Color(0xFF333333),
        fontSize: 16.sp,
        fontFamily: 'SBaggroB',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }
}
