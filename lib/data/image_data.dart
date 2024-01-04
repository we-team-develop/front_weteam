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
  static String get startweteambutton =>
      'assets/images/start_weteam_button.png';
  static String get profile1 => 'assets/images/profile_1.png';
  static String get profile2 => 'assets/images/profile_2.png';
  static String get profile3 => 'assets/images/profile_3.png';
  static String get profile4 => 'assets/images/profile_4.png';
  static String get profile5 => 'assets/images/profile_5.png';
  static String get profile6 => 'assets/images/profile_6.png';
  static String get homeOn => 'assets/images/home_on.png';
  static String get homeOff => 'assets/images/home_off.png';
  static String get myOn => 'assets/images/my_on.png';
  static String get myOff => 'assets/images/my_off.png';
  static String get tpOn => 'assets/images/tp_on.png';
  static String get tpOff => 'assets/images/tp_off.png';
}