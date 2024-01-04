import 'package:front_weteam/controller/bottom_nav_controller.dart';
import 'package:front_weteam/controller/login_controller.dart';
import 'package:get/get.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(BottomNavController());
  }
}
