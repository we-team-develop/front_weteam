import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/wtm_controller.dart';
import 'package:front_weteam/data/color_data.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:get/get.dart';

class WTMNaming extends GetView<WTMController> {
  const WTMNaming({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 67.h, left: 15.w),
        child: _head(),
      ),
      Padding(
        padding: EdgeInsets.only(top: 67.h, left: 15.w),
        child: _textfield(),
      ),
      Padding(
        padding: EdgeInsets.only(top: 418.h, left: 15.w),
        child: _bottom(),
      ),
    ]);
  }

  Widget _textfield() {
    return Container(
      width: 330.w,
      height: 39.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0.r),
        border: Border.all(
          color: AppColors.G_01,
          width: 1.0.w,
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 9.0.w),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.textController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '옆 동네 꽃밭 맛실 & 꿀 모아오기',
                    hintStyle: TextStyle(
                      fontFamily: 'NanumGothic',
                      fontSize: 14.sp,
                      color: AppColors.G_06,
                    ),
                    counterText: '',
                  ),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Obx(() => Padding(
                    padding: EdgeInsets.only(right: 9.0.w),
                    child: Text(
                      '${controller.textLength}/20',
                      style: TextStyle(
                        fontFamily: 'NanumGothic',
                        fontSize: 14.sp,
                        color: AppColors.G_06,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _head() {
    return Text(
      '약속 이름을 정해주세요!',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'NanumGothic',
          fontSize: 20.sp),
    );
  }

  Widget _bottom() {
    return Obx(
      () => Image.asset(
        controller.textController.text.isNotEmpty
            ? ImagePath.wtmnamingon
            : ImagePath.wtmnamingoff,
        width: 330.w,
        height: 40.h,
      ),
    );
  }
}
