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
      await _snackbarController!.close(withAnimations: false);
    }

    _snackbarController = Get.showSnackbar(GetSnackBar(
        title: title,
        message: content,
        backgroundColor: AppColors.G_04,
        snackPosition: SnackPosition.BOTTOM,
        icon: Image.asset(iconPath, width: 12.w, height: 12.h),
        duration: const Duration(seconds: 2),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 7.h),
        forwardAnimationCurve: Curves.easeOutCirc,
        reverseAnimationCurve: Curves.easeOutCirc,
        borderRadius: 8.r));
  }
}
