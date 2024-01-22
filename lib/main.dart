import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/app.dart';
import 'package:front_weteam/binding/main_bindings.dart';
import 'package:front_weteam/firebase_options.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:front_weteam/util/mem_cache.dart';
import 'package:front_weteam/view/login/login_main.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' hide User;
import 'package:shared_preferences/shared_preferences.dart';

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
  bool? isRegistered = sharedPreferences.getBool(SharedPreferencesKeys.isRegistered);
  if (isRegistered == true) {
    String? weteamUserJson = sharedPreferences.getString(
        SharedPreferencesKeys.weteamUserJson);

    User? fbUser = FirebaseAuth.instance.currentUser;
    if (fbUser != null && weteamUserJson != null) {
      MemCache.put(MemCacheKey.weteamUserJson, weteamUserJson);
      MemCache.put(MemCacheKey.firebaseAuthIdToken, await fbUser.getIdToken());
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late Widget home;

  MyApp({super.key});


  @override
  StatelessElement createElement() {
    Get.put(AuthService());
    home = Get.find<AuthService>().user == null ? const LoginMain() : const App();

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
                  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: const Color(0XFFE2583E)),
                  bottomNavigationBarTheme:
                      const BottomNavigationBarThemeData()),
              home: home,
              debugShowCheckedModeBanner: false, // Debug 배너 없애기
              initialBinding: MainBindings(),
            ));
  }
}

class SharedPreferencesKeys {
  static const String isRegistered = "is_registered";
  static const String dDayData = "dday_data";

  static const String weteamUserJson = "weteam_user_json";
  static const String teamProjectJson = "team_project_json";
}