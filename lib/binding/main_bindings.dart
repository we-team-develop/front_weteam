import 'package:front_weteam/controller/bottom_nav_controller.dart';
import 'package:front_weteam/controller/google_login_controller.dart';
import 'package:front_weteam/controller/home_controller.dart';
import 'package:front_weteam/controller/login_controller.dart';
import 'package:front_weteam/controller/my_controller.dart';
import 'package:front_weteam/controller/profile_controller.dart';
import 'package:get/get.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(BottomNavController());

    Get.put(HomeController());
    Get.put(MyController());
    Get.put(ProfileController());

    Get.put(GoogleLoginController());
  }
}
