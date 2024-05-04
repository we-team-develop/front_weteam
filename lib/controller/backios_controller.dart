import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io' show Platform;

import '../data/image_data.dart';

class CustomTitleBar extends StatelessWidget {
  final String title;

  CustomTitleBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (Platform.isIOS)
          Container(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                ImagePath.backios,
                width: 30.w,
                height: 30.h,
              ),
            ),
          ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontFamily: 'NanumGothic',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (Platform.isIOS)
          SizedBox(
            width: 30.w,
            height: 30.h,
          ), // 균형을 맞추기 위한 빈 박스
      ],
    );
  }
}
