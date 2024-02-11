import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/wtm_controller.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../data/color_data.dart';

class WTMCreateInputName extends GetView<WTMController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            _head(),

            SizedBox(height: 62.h),
            _TextInput(),

            Expanded(child: Container()),

            GestureDetector(
              onTap: () {
              },
              child: Obx(() => Container(
                width: 330.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: controller.nameInputText.value.isNotEmpty
                  ? AppColors.MainOrange
                  : AppColors.G_02,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Center(
                    child: Text('입력 완료',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'NanumGothicExtraBold',
                            fontSize: 15.sp))),
              )),
            ),
            SizedBox(height: 16.h)
          ],
        ),
      ),
    ));
  }

  Widget _head() {
    return Text(
      '약속의 이름을 정해주세요!',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'NanumGothic',
          fontSize: 20.sp),
    );
  }
}

class _TextInput extends GetView<WTMController> {
  final int maxLength = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.G_01, width: 1)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 8.w),
          Expanded(child: TextField(
            maxLines: 1,
            decoration: InputDecoration(
                border: InputBorder.none,
              counterText: "",
              hintText: "옆 동네 꽃밭 & 꿀 모아오기",
              hintStyle: TextStyle(
                fontFamily: "NanumGothic",
                fontSize: 14.sp,
                color: AppColors.G_06
              )
            ),
            maxLength: maxLength,
            onChanged: (value) => controller.nameInputText.value = value.trimRight(),
          )),
        Obx(() => Text(
                "${controller.nameInputText.value.length} / $maxLength",
                style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontSize: 12.sp,
                    color: AppColors.G_05),
              )),
          SizedBox(width: 8.w)
        ],
      ),
    );
  }
  
}