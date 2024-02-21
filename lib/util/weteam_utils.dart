import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import '../data/color_data.dart';
import '../data/image_data.dart';

enum SnackbarIcon {
  info, success, fail;
}

class WeteamUtils {
  static SnackbarController? _snackbarController;
  static void snackbar(title, content, {SnackbarIcon? icon}) async {
    late String iconPath;
    if (icon == SnackbarIcon.fail) {
      iconPath = ImagePath.snackbarFailIc;
    } else if (icon == SnackbarIcon.success) {
      iconPath = ImagePath.snackbarSuccessIc;
    } else {
      iconPath = ImagePath.snackbarInfoIc;
    }

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

    await closeSnackbarNow();

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

  static Future<void> closeSnackbarNow() async {
    if (_snackbarController != null) {
      try {
        await _snackbarController!.close(withAnimations: false);
        _snackbarController = null;
      } catch (_) {}
    }
  }

  /// DateTime을 String으로 변형합니다
  ///
  /// withTime: 시,분,초까지 포함합니다.
  static String formatDateTime(DateTime dt, {bool? withTime}) {
    String ret = "${padLeft(dt.year)}-${padLeft(dt.month)}-${padLeft(dt.day)}";
    if (withTime != null && withTime == true) {
      ret += "T${padLeft(dt.hour)}:${padLeft(dt.minute)}:${padLeft(dt.second)}";
    }
    return ret;
  }

  /// Num를 2글자 이상 String으로
  ///
  /// '''padLeft(3)''' -> '03'
  static String padLeft(int num) {
    return num.toString().padLeft(2, '0');
  }


  /// 시,분,초(mill,micro 포함)를 모두 0으로 설정합니다.
  static DateTime onlyDate(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }
}