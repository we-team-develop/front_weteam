import 'package:get/get.dart';

import '../controller/bottom_nav_controller.dart';
import '../controller/mainpage/home_controller.dart';
import '../controller/mainpage/my_page_controller.dart';
import '../controller/mainpage/tp_controller.dart';
import '../controller/profile_controller.dart';
import '../service/api_service.dart';
import '../service/auth_service.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthService());
    Get.put(ApiService());

    Get.put(BottomNavController());

    Get.put(HomeController());
    Get.put(ProfileController());
    Get.put(TeamPlayController());
    Get.put(MyPageController());
  }
}
