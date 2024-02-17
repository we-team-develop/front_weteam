import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import '../data/color_data.dart';
import '../data/image_data.dart';

class WeteamUtils {
  static SnackbarController? _snackbarController;
  static void snackbar(title, content, {String? iconPath}) async {
    iconPath ??= ImagePath.icCheckWhite;

    if (title == null || (title is String && title.isEmpty)) {
      title = null;
    } else {
      title = '$title';
    }

    if (content == null || (content is String && content.isEmpty)) {
      content = null;
    } else {
      content = '$content';
    }

    if (_snackbarController != null) {
      try {
        await _snackbarController!.close(withAnimations: false);
      } catch (_) {}
    }

    _snackbarController = Get.showSnackbar(GetSnackBar(
        titleText: title == null ? null : Text(
            title,
            style: TextStyle(
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: AppColors.White
            )),
        messageText: content == null ? null : Text(
          content,
          style: TextStyle(
            color: AppColors.White,
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.bold,
            fontSize: 13.sp
          )),
        backgroundColor: AppColors.G_04,
        snackPosition: SnackPosition.BOTTOM,
        icon: Image.asset(iconPath, width: 12.w, height: 12.h),
        duration: const Duration(seconds: 2),
        padding: const EdgeInsets.all(15).r,
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 7.h),
        forwardAnimationCurve: Curves.easeOutCirc,
        reverseAnimationCurve: Curves.easeOutCirc,
        borderRadius: 8.r));
  }
}
