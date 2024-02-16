import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/wtm_project.dart';

class WTMCurrentController extends GetxController {
  late final Rx<WTMProject> wtm;

  WTMCurrentController(WTMProject team) {
    wtm = team.obs;
  }
}
