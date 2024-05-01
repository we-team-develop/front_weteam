import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/meeting/meeting_current_controller.dart';
import '../../controller/meeting/meeting_schedule_controller.dart';
import '../../data/app_colors.dart';
import '../../util/weteam_utils.dart';
import '../widget/normal_button.dart';
import '../widget/meeting_widget.dart';
import '../widget/meeting_schedule_widget.dart';

class MeetingSelectTime extends StatefulWidget {
  const MeetingSelectTime({super.key});

  @override
  State<MeetingSelectTime> createState() => _MeetingSelectTimeState();
}

class _MeetingSelectTimeState extends State<MeetingSelectTime> {
  Map<String, HashSet<int>>? tmpSelectedMap; // 뒤로가기로 페이지 나가면 원래 값으로 되돌림
  final CurrentMeetingController controller = Get.find<CurrentMeetingController>();
  final MeetingScheduleController schController = Get.find<MeetingScheduleController>();

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
                  color: AppColors.g1,
                ),
                SizedBox(height: 14.h),
                // TODO : meeting_widget
                Obx(
                  () => MeetingWidget(
                    controller.meeting.value,
                    showlink: false,
                  ),
                ),
                SizedBox(height: 14.h),
                Divider(
                  height: 1.h,
                  color: AppColors.g1,
                ),
                SizedBox(height: 25.h),
                Expanded(
                    child: MeetingSchedule(controller.meeting.value, true)),
                SizedBox(height: 11.05.h),
              NormalButton(
                  text: '입력 완료',
                  onTap: () async {
                      bool success = await controller.setSelectedTimes();
                      await controller.fetchMeetingDetail(); // 정보 조회
                      if (!success) {
                        WeteamUtils.snackbar('', '오류로 인해 저장하지 못했어요');
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
