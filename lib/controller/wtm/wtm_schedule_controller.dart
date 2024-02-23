import 'dart:collection';

import 'package:get/get.dart';

class WTMScheduleController extends GetxController {
  final Rx<double> offset = 0.0.obs;
  final Rx<bool> selectionMode = RxBool(false);
  final RxMap<DateTime, HashSet<int>> selected = RxMap();

  DateTime? dt;

  @override
  void onInit() {
    super.onInit();
    selectionMode.listen((p0) {
      // 선택 모드가 해제될 때
      if (p0 == false) {
        selected.clear(); // Map 초기화
      }
    });
  }
}
