import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' hide User;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import 'app.dart';
import 'binding/main_bindings.dart';
import 'controller/home_controller.dart';
import 'controller/profile_controller.dart';
import 'data/color_data.dart';
import 'firebase_options.dart';
import 'service/api_service.dart';
import 'service/auth_service.dart';
import 'util/mem_cache.dart';
import 'util/weteam_utils.dart';
import 'view/login/login_main.dart';

late SharedPreferences sharedPreferences;
List<Function()> tpListUpdateRequiredListenerList = [];

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
  await _init();

  // 팀플 목록 30초마다 조회
  Timer.periodic(const Duration(seconds: 30), (timer) {
    try {
      if (MemCache.get(MemCacheKey.weteamUserJson) != null && MemCache.get(MemCacheKey.firebaseAuthIdToken) != null) {
        updateTeamProjectLists();
      }
    } catch (_) {}
  });

  runApp(Phoenix(child: MyApp()));
}

Future<void> _init() async {
  try {
    bool? isRegistered =
        sharedPreferences.getBool(SharedPreferencesKeys.isRegistered);
    if (isRegistered == true) {
      String? weteamUserJson =
          sharedPreferences.getString(SharedPreferencesKeys.weteamUserJson);

      User? fbUser = FirebaseAuth.instance.currentUser;
      if (fbUser != null && weteamUserJson != null) {
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

Future<void> updateTeamProjectLists() async {
  List<Future> futures = [];
  for (Function() func in tpListUpdateRequiredListenerList) {
    dynamic ret = func.call();
    if (ret is Future) futures.add(ret);
  }

  for (Future ft in futures) {
    await ft;
  }
}

class MyApp extends StatelessWidget {
  late Widget home;
  String lastPage = '';

  MyApp({super.key});

  @override
  StatelessElement createElement() {
    Get.put(AuthService());
    home = Get.find<AuthService>().user.value != null
        ? const App()
        : const LoginMain();

    linkStream.listen((event) async {
      if (event == null) return;
      bool isLoggedIn = Get.find<AuthService>().user.value != null;
      Uri uri = Uri.parse(event);

      String host = uri.host;
      String path = uri.path;
      Map<String, String> query = uri.queryParameters;

      if (host == "projects") {
        if (path.startsWith("/acceptInvite")) {
          int projectId = int.parse(query['id'] ?? '-1');
          if (!isLoggedIn) return;

          bool success = await Get.find<ApiService>().acceptInvite(projectId);
          if (success) {
            Get.find<HomeController>().updateTeamProjectList();
            WeteamUtils.snackbar('팀플에 참여함', '팀플 초대를 성공적으로 수락했어요!');
          } else {
            WeteamUtils.snackbar('오류', '팀플 초대를 수락하지 못했어요.');
          }
        }
      }
    });
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
                  scaffoldBackgroundColor: AppColors.White,
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: AppColors.MainOrange),
                  bottomNavigationBarTheme:
                      const BottomNavigationBarThemeData()),
              home: home,
              routingCallback: (routing) {
                if (routing == null) return;

                // 뒤로가기 액션이고 마지막 페이지가 Profile였을 때
                if (routing.isBack == true && lastPage.contains("Profile")) {
                  Get.find<ProfileController>().saveChanges();
                }

                // 현재 페이지의 정보를 기록합니다.
                lastPage = routing.current;
              },
              debugShowCheckedModeBanner: false, // Debug 배너 없애기
              initialBinding: MainBindings(),
            ));
  }
}

class SharedPreferencesKeys {
  static const String isRegistered = "is_registered";
  static const String dDayData = "dday_data";

  static const String weteamUserJson = "weteam_user_json";
  static const String teamProjectListJson = "team_project_list_json";
  static const String teamProjectDoneListJson = "team_project_done_list_json";
  static const String teamProjectNotDoneListJson =
      "team_project_not_done_list_json";
}

Future<void> resetApp() async {
  Get.deleteAll(force: true);
  MemCache.clear();
  _init();
  Phoenix.rebirth(Get.context!);
  Get.reset();
}
