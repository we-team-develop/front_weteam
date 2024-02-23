import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/color_data.dart';

class NormalButton extends StatefulWidget {
  final String text;
  final Function() onTap;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool whiteButton;
  final TextStyle? textStyle;
  final bool enable;

  const NormalButton({
    super.key,
    required this.onTap,
    this.text = "",
    this.width,
    this.height,
    this.fontSize,
    this.whiteButton = false,
    this.textStyle,
    this.enable = true
  });

  @override
  State<NormalButton> createState() => _NormalButtonState();
}

class _NormalButtonState extends State<NormalButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isLoading || !widget.enable) {
          return;
        }

        try {
          dynamic ret = widget.onTap();
          if (ret is Future) {
            setState(() {
              isLoading = true;
            });
            await ret;
          }
        } catch (_) {}

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 40.h,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: widget.whiteButton
                ? AppColors.White
                : (widget.enable ? AppColors.MainOrange : AppColors.G_02),
            shape:
              RoundedRectangleBorder(
                  side: widget.whiteButton
                    ? BorderSide(width: 1.r, color: AppColors.G_02)
                    : BorderSide.none,
                borderRadius: BorderRadius.circular(8.r)),
        ),
        child: Visibility(
          visible: !isLoading,
          replacement: const CircularProgressIndicator(),
          child: Text(
            widget.text,
            style: widget.textStyle ?? TextStyle(
              color: AppColors.White,
              fontSize: widget.fontSize ?? 15.sp,
              fontFamily: 'NanumGothicExtraBold',
            ),
          ),
        )
      ),
    );
  }
}
