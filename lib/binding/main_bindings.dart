import 'package:front_weteam/controller/bottom_nav_controller.dart';
import 'package:front_weteam/controller/home_controller.dart';
import 'package:front_weteam/controller/my_controller.dart';
import 'package:front_weteam/controller/profile_controller.dart';
import 'package:front_weteam/controller/tp_controller.dart';
import 'package:front_weteam/service/api_service.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:front_weteam/util/provider/weteam_auth_provider.dart';
import 'package:get/get.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavController());

    Get.put(HomeController());
    Get.put(MyController());
    Get.put(ProfileController());
    Get.put(TeamPlayController());

    Get.put(AuthService());
    Get.put(ApiService());

    Get.put(WeteamAuthProvider());
  }
}
