import 'package:flutter/material.dart';

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
  String inputValue = "";

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
                  "${inputValue.length} / ${widget.maxLength}",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 10,
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w400,
                    height: 0.26,
                  ),
                ),

          // hint 설정
          hintText: " ${widget.hint}",
          hintStyle: TextStyle(
            fontFamily: "NanumSquareNeo",
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black.withOpacity(0.3),
          ),

          // 각종 색 변경
          focusColor: const Color(0xFFE2583E),
          fillColor: const Color(0xFFE2583E),
          prefixIconColor: const Color(0xFFE2583E),
          suffixIconColor: const Color(0xFFE2583E),
          hoverColor: const Color(0xFFE2583E),
          iconColor: const Color(0xFFE2583E),

          // hint와 underline 사이의 공간 제거
          contentPadding: const EdgeInsets.all(0),
          isDense: true,

          // Underline의 색을 변경합니다
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE2583E)),
          )),
      cursorColor: const Color(0xFFE2583E), // 깜빡이는 커서의 색 변경
      maxLength: widget.maxLength, // 최대 20자

      onChanged: (newV) {
        setState(() {
          inputValue = newV;
        });
      },
    );
  }
}
