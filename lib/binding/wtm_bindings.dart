import 'package:get/get.dart';

import '../controller/wtm_controller.dart';

class WTMCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WTMController());
  }
}
