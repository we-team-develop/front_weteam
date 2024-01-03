import 'package:flutter/material.dart';
import 'package:front_weteam/splash_screen.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() {
  KakaoSdk.init(nativeAppKey: 'cbaa9e830b5eeee9794ea6dda548c4e8'); // kakaologin
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
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false, // Debug 배너 없애기
    );
  }
}
