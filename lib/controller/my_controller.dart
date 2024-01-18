import 'package:get/get.dart';

import '../service/auth_service.dart';

class MyController extends GetxController {
  String getUserName() {
    return Get.find<AuthService>().user?.username ?? "";
  }

  String getUserOrganization() {
    String? organization = Get.find<AuthService>().user?.organization;
    if (organization == null || organization.trim().isEmpty) {
      return "미입력";
    }
    return organization;
  }

  String getUserImgUrl() {
    throw UnimplementedError();
  }

  bool hasCompletedTeamProjects() {
    return true;
  }
}