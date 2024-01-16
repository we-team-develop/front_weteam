import 'package:flutter/widgets.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:front_weteam/util/custom_get_connect.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService extends CustomGetConnect implements GetxService {
  final String _baseUrl = "http://15.164.221.170:9090"; // baseUrl 주소

  @override
  void onInit() {
    super.onInit();

    httpClient
      ..baseUrl = _baseUrl
      ..timeout = const Duration(seconds: 15);
  }

  // 프로필 없으면 (회원가입 x) -1 반환
  Future<int?> getMyProfiles() async {
    Response rp = await get('/api/profiles'); // 회원가입 미완료시 404
    if (rp.statusCode == 200 || rp.statusCode == 404) {
      if (rp.statusCode == 404) {
        return -1;
      }

      String? body = rp.bodyString!;
      Map responseData = jsonDecode(body);

      return responseData['imageIdx'];
    } else {
      debugPrint("프로필 사진 ID를 가져오지 못함 : 서버가 ${rp.statusCode}으로 응답함");
      return null;
    }
  }

  Future<bool> createUserProfiles(int imageIdx) async {
    Response rp = await post('/api/profiles/$imageIdx', {});
    print(rp.bodyString);
    if (rp.statusCode != 201) {
      return false;
    } else {
      return true;
    }
  }

/*// GET requests 메소드 예제
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
*/

}