import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/color_data.dart';

class NormalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? color;
  final double? width;
  final double? height;

  const NormalButton({
    super.key,
    this.text = "",
    this.onTap,
    this.color,
    this.width = 185,
    this.height = 25.60,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width?.w,
        height: height?.h,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: color ?? AppColors.MainOrange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.White,
            fontSize: 10.sp,
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
