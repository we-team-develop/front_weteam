import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/wtm/wtm_current_controller.dart';
import '../../controller/wtm/wtm_schedule_controller.dart';
import '../../data/color_data.dart';
import '../../data/image_data.dart';
import '../../util/weteam_utils.dart';
import '../widget/normal_button.dart';
import '../widget/wtm_project_widget.dart';
import '../widget/wtm_schedule_widget.dart';

class WTMCurrent extends GetView<WTMCurrentController> {
  const WTMCurrent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 21.0.h),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head(),
          SizedBox(
            height: 16.h,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  height: 1.h,
                  color: AppColors.G_01,
                ),
                SizedBox(
                  height: 14.h,
                ),
                // TODO : wtm_widget
                Obx(
                  () => Stack(children: [
                    WTMProjectWidget(
                      controller.wtm.value,
                      showlink: false,
                    )
                  ]),
                ),
                SizedBox(
                  height: 14.h,
                ),
                Divider(
                  height: 1.h,
                  color: AppColors.G_01,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.w, top: 6.h),
                  child: Image.asset(
                    ImagePath.inforicon,
                    width: 19.w,
                    height: 19.h,
                  ),
                ),
                Expanded(
                    child: WTMSchedule(controller.wtm.value)),
                SizedBox(height: 11.05.h),
                Obx(() {
                  WTMScheduleController scheduleController = Get.find<
                      WTMScheduleController>();
                  late String buttonText;

                  if (scheduleController.selectionMode.isTrue) {
                    buttonText = "입력 완료";
                  } else {
                    buttonText = "가능 시간 입력";
                  }
                  return NormalButton(
                      text: buttonText,
                      onTap: () async {
                        WTMScheduleController scheduleController =
                            Get.find<WTMScheduleController>();
                        bool currentMode =
                            scheduleController.selectionMode.value;

                        // 서버에 저장하기
                        if (currentMode == true) {
                          bool success = await controller.setSelectedTimes();
                          await controller.fetchWTMProjectDetail(); // 정보 조회
                          if (!success) {
                            WeteamUtils.snackbar('저장하지 못했습니다', '오류가 있었습니다');
                          } else {
                            scheduleController.selectionMode.value =
                                !currentMode;
                          }
                        } else {
                          scheduleController.selectionMode.value = !currentMode;
                        }
                      });
                }),
                SizedBox(height: 12.h)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _head() {
    return Center(
      child: Text(
        '언제보까 현황',
        style: TextStyle(
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
