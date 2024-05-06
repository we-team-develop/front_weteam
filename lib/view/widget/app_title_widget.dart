import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/app_colors.dart';

class AppTitleWidget extends StatelessWidget {
  const AppTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'WE TEAM',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 16.sp,
        fontFamily: 'SBaggroB',
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }
}
