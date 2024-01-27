import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/wtm_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:get/get.dart';

class WTM extends GetView<WTMController> {
  const WTM({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 25.0.h),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        children: [
          _head(),
          SizedBox(
            height: 16.h,
          ),
          Expanded(
              child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    _wtmbody(),
                    Image.asset(
                      ImagePath.makewtmbutton,
                      width: 330.w,
                      height: 49.h,
                    )
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _head() {
    return Center(
      child: Text(
        '언제보까',
        style: TextStyle(
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _wtmbody() {
    return Obx(() {
      return _noWTMWidget();
    });
  }

  Widget _noWTMWidget() {
    return Expanded(
        child: SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Positioned(
                  right: 10,
                  bottom: 0,
                  child: Image.asset(
                    ImagePath.icEmptyTimi,
                    width: 75.55.w,
                    height: 96.h,
                  ),
                ),
                Text(
                  '생성된 언제보까가 없어요.\n지금 바로 생성해보세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF333333),
                    fontSize: 11.sp,
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
