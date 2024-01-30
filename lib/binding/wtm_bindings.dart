import 'package:front_weteam/controller/wtm_controller.dart';
import 'package:get/get.dart';

class WTMCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WTMController>(() => WTMController());
  }
}
