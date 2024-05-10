import 'package:get/get.dart';

import '../controller/profile_controller.dart';
import '../service/api_service.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService());
    Get.put(ProfileController());
  }

}