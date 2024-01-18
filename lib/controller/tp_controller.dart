import 'package:get/get.dart';

import '../service/auth_service.dart';

class TeamPlayController extends GetxController {
  String getUserName() {
    return Get.find<AuthService>().user?.username ?? "";
  }
}
