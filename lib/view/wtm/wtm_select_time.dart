import 'dart:collection';
import 'dart:developer';

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

class WTMSelectTime extends StatefulWidget {
  const WTMSelectTime({super.key});

  @override
  State<WTMSelectTime> createState() => _WTMSelectTimeState();
}

class _WTMSelectTimeState extends State<WTMSelectTime> {
  Map<String, HashSet<int>>? tmpSelectedMap; // 뒤로가기로 페이지 나가면 원래 값으로 되돌림
  final WTMCurrentController controller = Get.find<WTMCurrentController>();
  final WTMScheduleController schController = Get.find<WTMScheduleController>();

  @override
  void initState() {
    super.initState();

    Map<String, HashSet<int>> tmp = {};
    schController.selected.forEach((key, value) {
      tmp[key] = value;
    });

    tmpSelectedMap = tmp;
  }

  @override
  void dispose() {
    super.dispose();

    if (tmpSelectedMap != null) {
      schController.selected.clear();
      schController.selected.addAll(tmpSelectedMap!);
    }
  }

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
                  () => WTMProjectWidget(
                    controller.wtm.value,
                    showlink: false,
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                Divider(
                  height: 1.h,
                  color: AppColors.G_01,
                ),
                Expanded(
                    child: WTMSchedule(controller.wtm.value, true)),
                SizedBox(height: 11.05.h),
              NormalButton(
                  text: '입력 완료',
                  onTap: () async {
                      bool success = await controller.setSelectedTimes();
                      await controller.fetchWTMProjectDetail(); // 정보 조회
                      if (!success) {
                        WeteamUtils.snackbar('저장하지 못했습니다', '오류가 있었습니다');
                      } else {
                        await WeteamUtils.closeSnackbarNow();
                        tmpSelectedMap = null;
                        Get.back();
                      }
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
        '내 시간 입력',
        style: TextStyle(
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
