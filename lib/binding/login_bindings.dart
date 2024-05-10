import 'package:get/get.dart';

import '../controller/profile_controller.dart';
import '../service/api_service.dart';
import '../util/deep_link_handler.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService());
    Get.put(ProfileController());
    Get.put(DeepLinkService());
  }

}