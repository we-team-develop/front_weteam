import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/google_login_controller.dart';
import 'package:front_weteam/controller/login_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:get/get.dart';

class LoginMain extends GetView<LoginController> {
  final Rxn<String> loginInfo = Rxn();
  LoginMain({super.key});


  @override
  StatelessElement createElement() {
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    var padding = MediaQuery.of(context).size.height * 0.01; // 버튼 사이 패딩

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                ImagePath.appicon,
                width: 110.w,
                height: 140.h,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () async {
                  loginInfo.value = '로그인 완료 대기 중';
                  await Get.find<GoogleLoginController>().signInWithGoogle();
                  print("FCM 토큰을 받아오는 중");
                  String idToken = Get.find<GoogleLoginController>().idToken.value;
                  loginInfo.value = '브라우저에서 알림 권한을 허용해주세요!';
                  final String? fcmToken;
                  try {
                     fcmToken = await FirebaseMessaging.instance.getToken(
                        vapidKey: "BKgUNJLcIyG8a-mIG3i5RsPEBFwV-l2ezU258ntf9wQ9v7uVKjJ_M_Tj3u3wtItvfyiBpqBIUM2VqSnCvqZp-30");
                  } catch (e, st) {
                    print(e);
                    debugPrintStack(stackTrace: st);
                    loginInfo.value = 'fcmToken 받아오기 실패';
                    return;
                  }
                  if (fcmToken == null) {
                    loginInfo.value = '브라우저에서 알림 권한을 허용해주세요!(fcmToken == null)';
                  } else {
                    print(
                        "로그인 성공!\n===========idToken===========\n$idToken\n\n===========fcmToken===========\n$fcmToken");
                    loginInfo.value =
                    "로그인 성공!\n===========idToken===========\n$idToken\n\n===========fcmToken===========\n$fcmToken";
                  }
                },
                child: Image.asset(
                  ImagePath.googlelogin,
                  width: 302.w,
                  height: 39.h,
                ),
              ),
              Obx(() => SelectableText(loginInfo.value ?? "로그인 해주세요")),

              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            ],
          ),
        ],
      ),
    );
  }
}
