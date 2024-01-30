import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WTMCreate extends GetView<WTMCreate> {
  const WTMCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(top: 68.h, left: 15.w),
        child: _head(),
      ),
      SizedBox(
        height: 16.h,
      ),
    ]);
  }

  Widget _head() {
    return Text(
      '어떤 팀플의 약속인가요?',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'NanumGothic',
          fontSize: 20.sp),
    );
  }
}
