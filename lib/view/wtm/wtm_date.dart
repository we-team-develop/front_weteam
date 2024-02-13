import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/wtm_controller.dart';
import 'package:front_weteam/data/color_data.dart';
import 'package:front_weteam/view/widget/custom_calendart.dart';
import 'package:front_weteam/view/wtm/wtm_create_finish.dart';
import 'package:get/get.dart';

class WTMDate extends GetView<WTMController> {
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
        Expanded(child: CustomCalendar()),
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
    return GestureDetector(
      onTap: () {
        if (controller.nameInputText.value.isNotEmpty) {
          Get.to(() => WTMCreateFinish());
        } else {
          Get.snackbar(
            'Error',
            'Please enter a name for the appointment.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Obx(() => Container(
            width: 330.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: controller.nameInputText.value.isNotEmpty
                  ? AppColors.MainOrange
                  : AppColors.G_02,
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            child: Center(
                child: Text('입력 완료',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'NanumGothicExtraBold',
                        fontSize: 15.sp))),
          )),
    );
  }
}
