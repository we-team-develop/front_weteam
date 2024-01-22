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
}