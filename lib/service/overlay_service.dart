import 'package:shared_preferences/shared_preferences.dart';

class OverlayService {
  static const String _keyDoNotShowAgain = 'doNotShowOverlayAgain';

  /// 오버레이 표시 여부를 결정하는 함수
  static Future<bool> shouldShowOverlay() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDoNotShowAgain) ?? true;
  }

  /// "다시 보지 않기"를 설정하는 함수
  static Future<void> setDoNotShowOverlayAgain(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDoNotShowAgain, value);
  }
}
