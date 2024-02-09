import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

class WeteamUtils {
  static void snackbar(title, content) {
    Get.snackbar("$title", "$content",
        barBlur: 10,
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        animationDuration: const Duration(milliseconds: 500),
        snackPosition: SnackPosition.TOP);
  }
}
