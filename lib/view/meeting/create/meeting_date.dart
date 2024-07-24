import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/custom_calendar_controller.dart';
import '../../../controller/meeting/meeting_create_controller.dart';
import '../../../data/app_colors.dart';
import '../../widget/custom_calendart.dart';
import '../../widget/meeting_app_title_bar.dart';
import '../../widget/normal_button.dart';

class MeetingDate extends GetView<MeetingCreateController> {
  const MeetingDate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Align(alignment: Alignment.topLeft, child: _head()),
        ),
        SizedBox(
          height: 34.h,
        ),
        Divider(
          height: 1.h,
          color: AppColors.g2,
        ),
        SizedBox(
          height: 24.h,
        ),
        const Expanded(child: CustomCalendar()),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: _bottom(),
        ),
      ],
    );
  }

  Widget _head() {
    return const MeetingAppTitleBar(title: '언제부터 언제까지의 일정을\n조사할까요?');
  }

  Widget _bottom() {
    CustomCalendarController ccc = Get.find<CustomCalendarController>();
    return Obx(() {
      bool canFinish =
          ccc.selectedDt2.value != null && ccc.selectedDt2.value != null;
      return NormalButton(
        onTap: controller.finishCreatingOrEditing,
        text: '입력 완료',
        enable: canFinish,
        width: 330.w,
        height: 40.h,
      );
    });
  }
}
