import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final int? maxLength;
  final TextEditingController? controller;

  const CustomTextField(
      {super.key, this.hint = "", this.maxLength, this.controller});

  @override
  State<StatefulWidget> createState() {
    return _CustomTextFieldState();
  }
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onTapOutside: (v) {
        // 다른 곳 터치시 키보드 숨김
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
          // 기본 제공 카운터 제거
          counterText: "",
          suffix: widget.maxLength == null
              ? null
              : Text(
                  // TextField 오른쪽에 counter
                  "${widget.controller?.text.length} / ${widget.maxLength}",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 10.sp,
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w400,
                    height: 0.26,
                  ),
                ),

          // hint 설정
          hintText: " ${widget.hint}",
          hintStyle: TextStyle(
            fontFamily: "NanumSquareNeo",
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black.withOpacity(0.3),
          ),

          // 각종 색 변경
          focusColor: AppColors.mainOrange,
          fillColor: AppColors.mainOrange,
          prefixIconColor: AppColors.mainOrange,
          suffixIconColor: AppColors.mainOrange,
          hoverColor: AppColors.mainOrange,
          iconColor: AppColors.mainOrange,

          // hint와 underline 사이의 공간 5만큼
          contentPadding: EdgeInsets.only(bottom: 5.h),
          isDense: true,

          // Underline의 색을 변경합니다
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainOrange),
          )),
      cursorColor: AppColors.mainOrange,
      // 깜빡이는 커서의 색 변경
      maxLength: widget.maxLength,
      // 최대 20자

      style: TextStyle(
          fontFamily: 'NanumSquareNeo',
          fontSize: 18.sp,
          fontWeight: FontWeight.bold),
      onChanged: (newV) {
        setState(() {});
      },
    );
  }
}
