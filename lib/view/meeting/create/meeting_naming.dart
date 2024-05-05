import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/meeting/meeting_create_controller.dart';
import '../../../data/app_colors.dart';
import '../../widget/meeting_app_title_bar.dart';
import '../../widget/normal_button.dart';
import 'meeting_date.dart';

class MeetingNaming extends GetView<MeetingCreateController> {
  const MeetingNaming({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Column(
            children: [
              _head(),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: _body()))
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 62.h),
        child: _TextInput(),
      ),
      const Expanded(child: SizedBox()),
      Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: _bottom(),
      ),
    ]);
  }

  Widget _head() {
    return const MeetingAppTitleBar(
      title: '약속 이름을 정해주세요!',
    );
  }

  Widget _bottom() {
    return Obx(() => NormalButton(
          text: '입력 완료',
          onTap: () => Get.to(() => const MeetingDate()),
          enable: controller.nameInputText.value.isNotEmpty,
          width: 330.w,
          // 너비 설정
          height: 40.h, // 높이 설정
        ));
  }
}

class _TextInput extends GetView<MeetingCreateController> {
  final int maxLength = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.g1, width: 1.r)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 8.w),
          Expanded(
              child: TextField(
            maxLines: 1,
            controller: controller.nameInputController,
            style: TextStyle(fontSize: 14.sp, fontFamily: 'NanumGothic'),
            decoration: InputDecoration(
                border: InputBorder.none,
                counterText: "",
                hintText: "옆 동네 꽃밭 & 꿀 모아오기",
                hintStyle: TextStyle(
                    fontFamily: "NanumGothic",
                    fontSize: 14.sp,
                    color: AppColors.g6)),
            maxLength: maxLength,
            onChanged: (value) =>
                controller.nameInputText.value = value.trimRight(),
          )),
          Obx(() => Text(
                "${controller.nameInputText.value.length} / $maxLength",
                style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontSize: 12.sp,
                    color: AppColors.g5),
              )),
          SizedBox(width: 8.w)
        ],
      ),
    );
  }
}
