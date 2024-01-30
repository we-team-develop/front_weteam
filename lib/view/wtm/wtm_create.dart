import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/wtm_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:get/get.dart';

class WTMCreate extends GetView<WTMController> {
  const WTMCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 68.h, left: 15.w),
            child: _head(),
          ),
          SizedBox(
            height: 16.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: _search(),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              _tplist("진행중인 팀플", controller.selectedtpList.value == "진행중인 팀플"),
              _tplist("완료된 팀플", controller.selectedtpList.value == "완료된 팀플"),
            ],
          ),
        ],
      );
    });
  }

  Widget _head() {
    return Text(
      '어떤 팀플의 약속인가요?',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'NanumGothic',
          fontSize: 20.sp),
    );
  }

  Widget _search() {
    return Container(
      width: 330.w,
      height: 49.h,
      padding: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFd9d9d9), width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            ImagePath.icSearch,
            width: 36.w,
            height: 36.h,
          ),
        ],
      ),
    );
  }

  Widget _tplist(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.setSelectedtpList(text),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFE2583E) : Colors.transparent,
              width: 3.w,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color:
                isSelected ? const Color(0xFFE2583E) : const Color(0xFF333333),
          ),
        ),
      ),
    );
  }
}
