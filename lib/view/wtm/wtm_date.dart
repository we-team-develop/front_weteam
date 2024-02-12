import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/wtm_controller.dart';
import 'package:get/get.dart';

class WTMDate extends GetView<WTMController> {
  const WTMDate({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: _body(),
      ),
    ));
  }

  Widget _body() {
    return const Column();
  }
}
