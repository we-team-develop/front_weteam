import 'package:get/get.dart';

import '../service/auth_service.dart';

class MyController extends GetxController {
  String getUserName() {
    return Get.find<AuthService>().user.value?.username ?? "";
  }

  String getUserImgUrl() {
    throw UnimplementedError();
  }

  bool hasCompletedTeamProjects() {
    return true;
  }
}