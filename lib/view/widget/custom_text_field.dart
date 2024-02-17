import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/color_data.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final int? maxLength;
  final TextEditingController? controller;

  const CustomTextField({super.key, this.hint = "", this.maxLength, this.controller});

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
          focusColor: AppColors.MainOrange,
          fillColor: AppColors.MainOrange,
          prefixIconColor: AppColors.MainOrange,
          suffixIconColor: AppColors.MainOrange,
          hoverColor: AppColors.MainOrange,
          iconColor: AppColors.MainOrange,

          // hint와 underline 사이의 공간 제거
          contentPadding: const EdgeInsets.all(0),
          isDense: true,

          // Underline의 색을 변경합니다
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.MainOrange),
          )),
      cursorColor: AppColors.MainOrange, // 깜빡이는 커서의 색 변경
      maxLength: widget.maxLength, // 최대 20자

      style: TextStyle(
        fontFamily: 'NanumSquareNeo',
        fontSize: 18.sp,
        fontWeight: FontWeight.bold
      ),
      onChanged: (newV) {
        setState(() {
        });
      },
    );
  }
}
