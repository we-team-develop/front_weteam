import 'dart:collection';

import 'package:get/get.dart';


class WTMScheduleController extends GetxController {
  final Rx<double> verticalScrollOffset = 0.0.obs;

  final RxMap<String, HashSet<int>> selected = RxMap(); // <년-월-일, [1시,4시]>

  final RxInt maxPopulation = RxInt(0);
  final RxMap<String, int> populationMap = RxMap(); // <년-월-일T시, 4명>

  DateTime? dt;
}
