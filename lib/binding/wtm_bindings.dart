import 'package:get/get.dart';

import '../controller/wtm/wtm_controller.dart';

class WTMBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(WTMController());
  }
}
