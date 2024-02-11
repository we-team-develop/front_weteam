import 'package:shared_preferences/shared_preferences.dart';

class OverlayService {
  static const String _keyDoNotShowAgain = 'doNotShowOverlayAgain';

  static Future<bool> shouldShowOverlay() async {
    final prefs = await SharedPreferences.getInstance();
    bool shouldShow =
        prefs.getBool(_keyDoNotShowAgain) ?? true; // 기본값은 true로 설정
    // 로그 출력 추가
    print('SharedPreferences loaded: $_keyDoNotShowAgain = $shouldShow');
    return !(prefs.getBool(_keyDoNotShowAgain) ?? false);
  }

  static Future<void> setDoNotShowOverlayAgain(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDoNotShowAgain, value);
    // 로그 출력 추가
    print('SharedPreferences saved: $_keyDoNotShowAgain = $value');
  }
}
