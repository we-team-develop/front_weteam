import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CustomCalendarController extends GetxController {
  /// 현재 시간
  DateTime now = DateTime.now();

  /// 첫 번째로 선택된 시점
  Rxn<DateTime> selectedDt1 = Rxn();

  /// 두 번째로 선택된 시점
  Rxn<DateTime> selectedDt2 = Rxn();
}
