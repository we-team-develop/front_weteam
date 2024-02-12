import 'package:flutter/foundation.dart';

import '../main.dart';

class OverlayService {
  static const String _keyShowOverlay =
      SharedPreferencesKeys.showWTMOverlay;

  static bool shouldShowOverlay() {
    final prefs = sharedPreferences;
    bool shouldShow =
        prefs.getBool(_keyShowOverlay) ?? true; // 기본값은 true로 설정
    // 로그 출력 추가
    debugPrint('SharedPreferences loaded: $_keyShowOverlay = $shouldShow');
    return shouldShow;
  }

  static Future<void> setShouldShowOvelay(bool value) async {
    final prefs = sharedPreferences;
    await prefs.setBool(_keyShowOverlay, value);
    // 로그 출력 추가
    debugPrint('SharedPreferences saved: $_keyShowOverlay = $value');
  }
}
