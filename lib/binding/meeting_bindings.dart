import 'package:get/get.dart';

import '../controller/meeting/meeting_controller.dart';

class MeetingBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MeetingController());
  }
}
