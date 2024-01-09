import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:front_weteam/social/create_firebase_custom_token.dart';

class ApiService extends GetxService {
  final String _baseUrl = "http://15.164.221.170:9090/api"; // baseUrl 주소/api

  // GET requests 메소드 예제
  Future<http.Response> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl$endpoint'));
    return response;
  }

  // POST requests 메소드 예제
  Future<http.Response> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return response;
  }

  // send idToken to the server for authentication 메소드 예제
  Future<http.Response> authenticateWithIdToken(String idToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/your-authentication-endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'idToken': idToken}),
    );
    return response;
  }

  // Naver_controller 분리
  Future<String> getToken() async {
    if (!(await isLoggedIn())) {
      debugPrint("NaverLoginController: getToken이 호출되었지만 로그인 상태가 아님");
      return "";
    }

    return await FirebaseAuth.instance.currentUser?.getIdToken() ?? "";
  }

  Future<String> getAccessToken() async {
    final NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
    return res.accessToken;
  }

  @override
  Future<bool> isLoggedIn() async {
    return await FlutterNaverLogin.isLoggedIn;
  }

  @override
  Future<bool> login() async {
    try {
      await FlutterNaverLogin.logIn();
      bool success = await isLoggedIn(); // 성공 여부

      if (!success) {
        return false;
      }

      String accessToken = await getAccessToken(); // 네이버 액세스 토큰을 받아옴

      // FirebaseToken 생성 시작
      final customToken = await createFirebaseCustomToken(
        accessToken: accessToken,
        loginType: 'naverCustomAuth', // 네이버 커스텀 auth 함수 사용
      );
      final userCredential = await FirebaseAuth.instance
          .signInWithCustomToken(customToken); // fb 로그인
      return userCredential.user != null;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await FlutterNaverLogin.logOut();
      return true;
    } catch (error) {
      return false;
    }
  }
}
