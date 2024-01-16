import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:front_weteam/model/weteam_user.dart';
import 'package:front_weteam/util/custom_get_connect.dart';
import 'package:get/get.dart';

class WeteamAuthProvider extends CustomGetConnect {
  @override
  void onInit() {
    super.onInit();

    httpClient
      ..baseUrl = 'http://15.164.221.170:9090'
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
}
