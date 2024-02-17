import 'package:get/get.dart';

class WTMScheduleController extends GetxController {
  DateTime? dt;
  Rx<double> offset = 0.0.obs;
  Rx<bool> selectionMode = RxBool(false);
}
