import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/bottom_nav_controller.dart';
import '../../data/image_data.dart';

class CustomTitleBar extends StatelessWidget {
  static const double iconSize = 30.0;
  final bool strongFont;
  final bool useNavController;
  final String title;

  const CustomTitleBar(
      {super.key,
      this.title = "WE TEAM",
      this.strongFont = false,
      this.useNavController = false});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // iOS: 중앙 정렬 + 뒤로 가기 버튼
      return _iosAppBar();
    } else {
      // Android: 왼쪽 정렬
      return _androidAppBar();
    }
  }

  Widget _androidAppBar() {
    if (strongFont) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [SizedBox(width: 15.w), _titleWidget()]);
    } else {
      return _titleWidget();
    }
  }

  Row _iosAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 8.w),
        Container(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              if (useNavController) {
                BottomNavController navController =
                    Get.find<BottomNavController>();
                navController.popAction();
              } else {
                Get.back();
              }
            },
            child: Image.asset(
              ImagePath.backios,
              width: iconSize.w,
              height: iconSize.h,
            ),
          ),
        ),
        _titleWidget(),
        if (Platform.isIOS)
          SizedBox(
            width: iconSize.w,
            height: iconSize.h,
          ), // 균형을 맞추기 위한 빈 박스
      ],
    );
  }

  Widget _titleWidget() {
    Text t = Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: strongFont ? 16.sp : 14.sp,
        fontFamily: strongFont ? 'SBaggroB' : 'NanumGothic',
        fontWeight: strongFont ? FontWeight.w600 : FontWeight.bold,
      ),
    );
    if (strongFont) {
      return t;
    } else {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(child: Container()),
        t,
        Expanded(child: Container())
      ]);
    }
  }
}
