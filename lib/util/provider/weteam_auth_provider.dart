import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:front_weteam/model/weteam_user.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:get/get.dart';

class WeteamAuthProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();

    httpClient
    ..baseUrl = 'http://15.164.221.170:9090/'
    ..timeout = const Duration(seconds: 15);
  }

  Map<String, String> getHeader() {
    Map<String, String> headers = {'Authorization': 'Bearer ${Get.find<AuthService>().token}'};

    return headers;
  }

  Future<WeteamUser?> getCurrentUser() async {
    Response rp = await get('api/users', headers: getHeader());
    if (rp.statusCode != 200) {
      debugPrint("statusCode가 200이 아님 (${rp.statusCode} ,,, ${rp.request!.url.toString()}");
      return null;
    }

    String? json = rp.bodyString;
    if (json == null) {
      debugPrint("bodyString is null");
      return null;
    }

    return WeteamUser.fromJson(jsonDecode(json));
  }
}