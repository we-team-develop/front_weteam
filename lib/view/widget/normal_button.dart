import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NormalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const NormalButton({super.key, this.text = "", this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 185.w,
        height: 25.60.h,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: const Color(0xFFE2583E),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 10.sp,
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}