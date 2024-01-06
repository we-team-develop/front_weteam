import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front_weteam/binding/main_bindings.dart';
import 'package:front_weteam/firebase_options.dart';
import 'package:front_weteam/splash_screen.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  await dotenv.load(fileName: ".env"); // .env 파일 런타임에 가져오기
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
    return GetMaterialApp(
      theme: ThemeData(
          //AppBar 설정
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0.0,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData()),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false, // Debug 배너 없애기
      initialBinding: MainBindings(),
    );
  }
}
