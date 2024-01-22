import 'package:flutter/widgets.dart';
import 'package:front_weteam/util/custom_get_connect.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../main.dart';
import '../model/weteam_user.dart';

class ApiService extends CustomGetConnect implements GetxService {
  final String _baseUrl = "http://15.164.221.170:9090"; // baseUrl 주소

  @override
  void onInit() {
    super.onInit();

    httpClient
      ..baseUrl = _baseUrl
      ..timeout = const Duration(seconds: 15);
  }

  Future<WeteamUser?> getCurrentUser() async {
    Response rp = await get('/api/users');
    if (rp.statusCode != 200) {
      debugPrint(
          "statusCode가 200이 아님 (${rp.statusCode} ,,, ${rp.request!.url.toString()}");
      return null;
    }

    String? json = rp.bodyString;
    print('$json');
    if (json == null) {
      debugPrint("bodyString is null");
      return null;
    }

    sharedPreferences.setString(SharedPreferencesKeys.weteamUserJson ,json);

    return WeteamUser.fromJson(jsonDecode(json));
  }


  Future<bool> withdrawal() async {
    Response rp = await delete('/api/users');
    if (rp.statusCode == 204) { // 탈퇴 성공시 204
      return true;
    } else {
      debugPrint(rp.bodyString);
      return false;
    }
  }

  // 프로필 없으면 (회원가입 x) -1 반환
  Future<int?> getMyProfiles() async {
    Response rp = await get('/api/profiles'); // 회원가입 미완료시 404

    String? body = rp.bodyString!;
    Map responseData = jsonDecode(body);

    int? statusCode = responseData['statusCode'] ?? rp.statusCode;
    if (statusCode == 200 || statusCode == 404 || statusCode == 500) {

      if (statusCode == 404) {
        return -1;
      }
      if (statusCode == 500) {
        if (responseData['message'] != null) {
          if (responseData['message'].contains('조회할')) return -1;
        } else {
          return null;
        }
      }

      return responseData['imageIdx'];
    } else {
      debugPrint("프로필 사진 ID를 가져오지 못함 : 서버가 $statusCode으로 응답함");
      return null;
    }
  }

  Future<bool> createUserProfiles(int imageIdx) async {
    Response rp = await post('/api/profiles/$imageIdx', {});
    if (rp.statusCode != 201) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> createTeamProject(String name, DateTime startedAt, DateTime endedAt, String explanation) async {
    Map data = {
      'name': name,
      'startedAt': "${startedAt.year}-${startedAt.month.toString().padLeft(2, '0')}-${startedAt.day.toString().padLeft(2, '0')}",
      'endedAt': "${endedAt.year}-${endedAt.month.toString().padLeft(2, '0')}-${endedAt.day.toString().padLeft(2, '0')}",
      'explanation': explanation
    };
    Response rp = await post('/api/projects', data);
    print(rp.bodyString);
    return rp.statusCode == 201;
  }
}