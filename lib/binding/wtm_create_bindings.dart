import 'package:get/get.dart';

import '../controller/custom_calendar_controller.dart';
import '../controller/wtm/wtm_create_controller.dart';

class WTMCreateBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(WTMCreateController());
    Get.put(CustomCalendarController());
  }
}