import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/binding/main_bindings.dart';
import 'package:front_weteam/firebase_options.dart';
import 'package:front_weteam/splash_screen.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  // 가로모드 X
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // .env 파일 런타임에 가져오기
  await dotenv.load(fileName: ".env");

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  KakaoSdk.init(nativeAppKey: dotenv.env['nativeAppKey']); // kakaologin

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
              home: const SplashScreen(),
              debugShowCheckedModeBanner: false, // Debug 배너 없애기
              initialBinding: MainBindings(),
            ));
  }
}
