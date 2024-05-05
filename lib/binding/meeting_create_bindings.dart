import 'package:get/get.dart';

import '../controller/custom_calendar_controller.dart';
import '../controller/meeting/meeting_create_controller.dart';

class MeetingCreateBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MeetingCreateController());
    Get.put(CustomCalendarController());
  }
}
