import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../binding/wtm_create_bindings.dart';
import '../../controller/wtm/wtm_controller.dart';
import '../../data/color_data.dart';
import '../../data/image_data.dart';
import '../../model/wtm_project.dart';
import '../widget/wtm_project_column.dart';
import 'create/wtm_create.dart';

class WTM extends GetView<WTMController> {
  WTM({super.key});

  final overlayKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.showOverlay(context);
    });
    return Scaffold(
      key: overlayKey,
      body: Padding(
        padding: EdgeInsets.only(top: 47.0.h),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.updateWTMProjectList();
          },
          child: _body(),
        ),
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
          Expanded(
            child: Obx(() {
              if (controller.wtmList.value == null ||
                  controller.wtmList.value!.isEmpty) {
                return _noWTMWidget();
              } else {
                List<WTMProject> wtmList = controller.wtmList.value!;
                return WTMProjectListView(wtmList,
                    scrollController: controller.wtmScrollController);
              }
            }),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25.h),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => const WTMCreate(), binding: WTMCreateBindings());
                },
                child: _newWTMButton()),
          )
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

  Widget _noWTMWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 153.h),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    ImagePath.wtmEmptyTimi,
                    width: 127.w,
                    height: 131.h,
                  ),
                  Text(
                    '생성된 언제보까가 없어요.\n지금 바로 생성해보세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.Black,
                      fontSize: 11.sp,
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newWTMButton() {
    return Image.asset(
      ImagePath.makewtmbutton,
      width: 330.w,
      height: 49.h,
    );
  }
}
