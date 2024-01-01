import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageData extends StatelessWidget {
  final String path;
  final double width;
  const ImageData({super.key, required this.path, this.width = 60});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width / Get.mediaQuery.devicePixelRatio,
    );
  }
}

class ImagePath {
  static String get splash => 'assets/images/splash.png';
  static String get appicon => 'assets/images/app_icon.png';
  static String get googlelogin => 'assets/images/login_google.png';
  static String get kakaologin => 'assets/images/kakao_login_large_wide.png';
  static String get naverlogin => 'assets/images/naver_login.png';
  static String get applelogin => 'assets/images/apple_login.png';
}
