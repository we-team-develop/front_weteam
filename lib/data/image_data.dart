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

  static String get appIcon => 'assets/images/app_icon.png';

  static String get googleLogin => 'assets/images/login_google.png';

  static String get kakaoLogin => 'assets/images/kakao_login_large_wide.png';

  static String get naverLogin => 'assets/images/naver_login.png';

  static String get appleLogin => 'assets/images/apple_login.png';

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

  static String get check => 'assets/images/check.png';

  static String get icBell => 'assets/images/ic_bell.png';

  static String get icSearch => 'assets/images/ic_search.png';

  static String get icBellNew => 'assets/images/ic_bell_new.png';

  static String get icEmptyTimi => 'assets/images/ic_empty_timi.png';

  static String get meetingEmptyTimi => 'assets/images/meeting_empty_timi.png';

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

  static String get makeMeetingButton =>
      'assets/images/make_meeting_button.png';

  static String get meetingTutorial1 => 'assets/images/tutorial_1.png';

  static String get meetingTutorial2 => 'assets/images/tutorial_2.png';

  static String get meetingCross => 'assets/images/meeting_cross.png';

  static String get icSolarCrownBold => 'assets/images/ic_solar_crown-bold.png';

  static String get icCheckWhite => 'assets/images/ic_check_white.png';

  static String get icCheckWhiteActivated =>
      'assets/images/ic_check_white_activated.png';

  static String get icHostOutGray => 'assets/images/ic_hostout_gray.png';

  static String get icGuestOutGray => 'assets/images/ic_guestout_gray.png';

  static String get checkTutorialFalse =>
      'assets/images/tutorial_checkbox_false.png';

  static String get checkTutorialTrue =>
      'assets/images/tutorial_checkbox_true.png';

  static String get greenCheck => 'assets/images/green_check.png';

  static String get thumbTimi => 'assets/images/thumb_timi.png';

  static String get meetingLink => 'assets/images/meeting_list_link.png';

  static String get inforIcon => 'assets/images/infor_icon.png';

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

  static String get snackbarFailIc => 'assets/images/snackbar_fail_ic.png';

  static String get snackbarSuccessIc =>
      'assets/images/snackbar_success_ic.png';

  static String get snackbarInfoIc => 'assets/images/snackbar_info_ic.png';

  static String get infoImage => 'assets/images/meeting_info_overlay_color.png';

  static String get icCrossClose => 'assets/images/ic_cross_close.png';

  static String get meeting1 => 'assets/images/meeting1.png';

  static String get meeting2 => 'assets/images/meeting2.png';

  static String get meeting3 => 'assets/images/meeting3.png';

  static String get meeting4 => 'assets/images/meeting4.png';

  static String get meeting5 => 'assets/images/meeting5.png';

  static String get meeting6 => 'assets/images/meeting6.png';

  static String get meeting7 => 'assets/images/meeting7.png';

  static String get meeting8 => 'assets/images/meeting8.png';

  static String get meeting9 => 'assets/images/meeting9.png';

  static String get meeting10 => 'assets/images/meeting10.png';

  static String get backios => 'assets/images/backios.png';
}
