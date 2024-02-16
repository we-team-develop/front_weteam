import 'package:flutter/material.dart';
import '../../controller/wtm_current_controller.dart';
import 'package:get/get.dart';

class WTMCurrent extends GetView<WTMCurrentController> {
  const WTMCurrent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return const Column();
  }
}
