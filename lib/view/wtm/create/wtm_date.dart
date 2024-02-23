import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/custom_calendar_controller.dart';
import '../../../controller/wtm/wtm_controller.dart';
import '../../../controller/wtm/wtm_create_controller.dart';
import '../../../data/color_data.dart';
import '../../../model/wtm_project.dart';
import '../../../service/api_service.dart';
import '../../../util/weteam_utils.dart';
import '../../widget/custom_calendart.dart';
import '../../widget/normal_button.dart';
import 'wtm_create_finish.dart';

class WTMDate extends GetView<WTMCreateController> {
  const WTMDate({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _body(),
    ));
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40.h, left: 15.w),
          child: Align(alignment: Alignment.topLeft, child: _head()),
        ),
        SizedBox(
          height: 34.h,
        ),
        Divider(
          height: 1.h,
          color: AppColors.G_02,
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
    return Text(
      '언제부터 언제까지의 일정을\n조사할까요?',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'NanumGothic',
          fontSize: 20.sp),
    );
  }

  Widget _bottom() {
    CustomCalendarController ccc = Get.find<CustomCalendarController>();

    return Obx(() {
      bool canFinish =
          ccc.selectedDt2.value != null && ccc.selectedDt2.value != null;
      return NormalButton(
        onTap: canFinish
            ? () async {
                if (ccc.selectedDt2.value!.isBefore(ccc.selectedDt1.value!)) {
                  controller.startedAt = ccc.selectedDt2.value!;
                  controller.endedAt = ccc.selectedDt1.value!;
                } else {
                  controller.startedAt = ccc.selectedDt1.value!;
                  controller.endedAt = ccc.selectedDt2.value!;
                }

                String title = controller.nameInputText.value.trim();
                DateTime startedAt = controller.startedAt!;
                DateTime endedAt = controller.endedAt!;
                int? projectId = controller.selectedTeamProject.value?.id;

                bool success = false;

                if (controller.wtmProject == null) {
                  WTMProject? wtmProject = await Get.find<ApiService>()
                      .createWTM(
                          title: title,
                          startedAt: startedAt,
                          endedAt: endedAt,
                          projectId: projectId);

                  success = (wtmProject != null);
                  if (success) {
                    controller.wtmProject = wtmProject;
                  }
                } else {
                  int wtmId = controller.wtmProject!.id;
                  success = await Get.find<ApiService>().editWTM(
                      wtmProjectId: wtmId,
                      title: title,
                      startedAt: startedAt,
                      endedAt: endedAt);
                }

                if (success) {
                  Get.find<WTMController>().updateWTMProjectList();
                  Get.to(() => const WTMCreateFinish());
                } else {
                  WeteamUtils.snackbar('생성 실패', '오류가 발생했습니다',
                      icon: SnackbarIcon.fail);
                }
              }
            : null,
        text: '입력 완료',
        color: canFinish ? AppColors.MainOrange : AppColors.G_02,
        width: 330,
        height: 40,
      );
    });
  }
}
