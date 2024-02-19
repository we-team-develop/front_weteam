import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageData extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  const ImageData(
      {super.key, required this.path, this.width = 60, this.height = 60});

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
  static String get startweteambuttonOff =>
      'assets/images/start_weteam_button_off.png';
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
  static String get bottomBannerIcon => 'assets/images/bottom_banner_icon.png';
  static String get nextButton => 'assets/images/nextbutton.png';
  static String get check => 'assets/images/check.png';
  static String get icBell => 'assets/images/ic_bell.png';
  static String get icSearch => 'assets/images/ic_search.png';
  static String get icBellNew => 'assets/images/ic_bell_new.png';
  static String get icEmptyTimi => 'assets/images/ic_empty_timi.png';
  static String get wtmEmptyTimi => 'assets/images/wtm_empty_timi.png';
  static String get icGroup => 'assets/images/ic_group.png';
  static String get icKebabWhite => 'assets/images/ic_kebab_white.png';
  static String get icPinWhite => 'assets/images/ic_pin_white.png';
  static String get icPlus => 'assets/images/ic_plus.png';
  static String get icPlusSquareLight =>
      'assets/images/ic_plus_square_light.png';
  static String get tpBanner => 'assets/images/tp_banner.png';
  static String get icRightGray30 => 'assets/images/ic_right_gray_30px.png';
  static String get myNoTeamProjectTimi =>
      'assets/images/my_no_team_project_timi.png';
  static String get makewtmbutton => 'assets/images/make_wtm_button.png';
  static String get wtmtutorial1 => 'assets/images/tutorial_1.png';
  static String get wtmtutorial2 => 'assets/images/tutorial_2.png';
  static String get wtmcross => 'assets/images/wtm_cross.png';
  static String get icSolarCrownBold => 'assets/images/ic_solar_crown-bold.png';
  static String get icCheckWhite => 'assets/images/ic_check_white.png';
  static String get icCheckWhiteActivated =>
      'assets/images/ic_check_white_activated.png';
  static String get icHostoutGray => 'assets/images/ic_hostout_gray.png';
  static String get checktutorialfalse =>
      'assets/images/tutorial_checkbox_false.png';
  static String get checktutorialtrue =>
      'assets/images/tutorial_checkbox_true.png';
  static String get greenCheck => 'assets/images/green_check.png';
  static String get thumbTimi => 'assets/images/thumb_timi.png';
  static String get wtmlink => 'assets/images/wtm_list_link.png';
  static String get inforicon => 'assets/images/infor_icon.png';
  static String get loggedInGoogle => 'assets/images/loggedin_google.png';
  static String get loggedInKakao => 'assets/images/loggedin_kakao.png';
  static String get loggedInNaver => 'assets/images/loggedin_naver.png';
  static String get loggedInApple => 'assets/images/loggedin_apple.png';
  static String get bigWeteamTimiIcon => 'assets/images/big_weteam_timi_ic.png';
  static String get tpImage1 => 'assets/images/1@4x.png';
  static String get tpImage2 => 'assets/images/2@4x.png';
  static String get tpImage3 => 'assets/images/3@4x.png';
  static String get tpImage4 => 'assets/images/4@4x.png';
  static String get tpImage5 => 'assets/images/5@4x.png';
  static String get tpImage6 => 'assets/images/6@4x.png';
  static String get tpImage7 => 'assets/images/7@4x.png';
  static String get tpImage8 => 'assets/images/8@4x.png';
  static String get tpImage9 => 'assets/images/9@4x.png';
  static String get tpImage10 => 'assets/images/10@4x.png';
  static asset(String googlelogin,
      {required double width, required double height}) {}
}
