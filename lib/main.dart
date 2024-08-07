import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' hide User;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'binding/login_bindings.dart';
import 'binding/main_bindings.dart';
import 'controller/team_project_detail_page_controller.dart';
import 'data/app_colors.dart';
import 'firebase_options.dart';
import 'service/auth_service.dart';
import 'service/team_project_service.dart';
import 'util/mem_cache.dart';
import 'view/login/login_main.dart';

late SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  // 가로모드 X
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Futures
  Future firebaseFuture = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Future dotEnvFuture = dotenv.load(fileName: ".env");
  Future sharedPreferencesFuture = SharedPreferences.getInstance();

  // .env 파일 런타임에 가져오기
  await dotEnvFuture;
  KakaoSdk.init(nativeAppKey: dotenv.env['nativeAppKey']); // kakaologin

  // SharedPreferences 로드 대기
  sharedPreferences = await sharedPreferencesFuture;

  // Firebase 초기화 대기
  await firebaseFuture;
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Permission.notification.request();
  FirebaseMessaging.onMessage.listen((event) async {
    String? title = event.notification?.title;
    String? body = event.notification?.body;
    if (title == null || body == null) {
      return;
    }

    if (!(body.contains("환영") || body.contains("멤버와는") || body.contains("응원") || body.contains("가세요"))) {
       return;
    }

    TeamProjectService service = Get.find<TeamProjectService>();
    service.updateLists();

    try {
      TeamProjectDetailPageController controller = Get.find<
          TeamProjectDetailPageController>();
      controller.fetchUserList();
    } catch (_) {
    }
  });

  await _initApp();

  /**
   * 3분 업데이트
   * _makeTeamProjectListRefreshTimer();
   */

  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  late Widget home;
  String lastPage = '';
  Bindings? bindings;

  MyApp({super.key});

  @override
  StatelessElement createElement() {
    Get.put(AuthService());
    bool loggedIn = Get.find<AuthService>().user.value != null;
    home = loggedIn ? const App() : LoginMain();
    bindings = loggedIn ? MainBindings() : LoginBindings();

    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 720),
        builder: (_, child) => GetMaterialApp(
              theme: ThemeData(
                  //AppBar 설정
                  appBarTheme: const AppBarTheme(
                    centerTitle: true,
                    elevation: 0.0,
                  ),
                  scaffoldBackgroundColor: AppColors.white,
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: AppColors.mainOrange),
                  bottomNavigationBarTheme:
                      const BottomNavigationBarThemeData()),
              home: home,
              debugShowCheckedModeBanner: false, // Debug 배너 없애기
              initialBinding: bindings,
            ));
  }
}

class SharedPreferencesKeys {
  static const String isRegistered = "is_registered";
  static const String dDayData = "dday_data";

  static const String weteamUserJson = "weteam_user_json";
  static const String teamProjectDoneListJson = "team_project_done_list_json";
  static const String teamProjectNotDoneListJson =
      "team_project_not_done_list_json";

  static const String showMeetingOverlay = "show_meeting_overlay";
}

/// 앱 실행을 위한 초기화 수행
Future<void> _initApp() async {
  try {
    // 회원가입이 완료되어 있는 상태였는지 확인
    bool? isRegistered =
        sharedPreferences.getBool(SharedPreferencesKeys.isRegistered);

    if (isRegistered == true) {
      // 회원가입이 완료되어 있던 회원
      String? weteamUserJson =
          sharedPreferences.getString(SharedPreferencesKeys.weteamUserJson);

      User? fbUser = FirebaseAuth.instance.currentUser;
      if (fbUser != null && weteamUserJson != null) {
        // 로그인 정보가 남아 있다면
        MemCache.put(MemCacheKey.weteamUserJson, weteamUserJson);
        MemCache.put(
            MemCacheKey.firebaseAuthIdToken, await fbUser.getIdToken());
      }
    }
  } catch (e, st) {
    debugPrint("앱 초기화 실패 : $e\n$st");
    MemCache.put(MemCacheKey.weteamUserJson, null);
    MemCache.put(MemCacheKey.firebaseAuthIdToken, null);
  }
}

/// 앱을 재실행합니다
Future<void> resetApp() async {
  Get.deleteAll(force: true);
  MemCache.clear();
  await _initApp();
  Phoenix.rebirth(Get.context!);
  Get.reset();
}