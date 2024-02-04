import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CustomCalendarController extends GetxController {
  DateTime now = DateTime.now();
  Rxn<DateTime> selectedDt1 = Rxn();
  Rxn<DateTime> selectedDt2 = Rxn();
}