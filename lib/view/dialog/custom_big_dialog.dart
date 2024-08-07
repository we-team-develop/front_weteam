import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/app_colors.dart';

class CustomBigDialog extends StatelessWidget {
  final String title;
  final Widget child;

  const CustomBigDialog({super.key, this.title = "", required this.child});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      titlePadding: EdgeInsets.symmetric(vertical: 29.h),
      contentPadding: const EdgeInsets.all(16).r,
      //Dialog Main Title
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 12.sp,
          fontFamily: 'NanumSquareNeo',
          fontWeight: FontWeight.w800,
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 272.w),
        child: child,
      ),
    );
  }
}