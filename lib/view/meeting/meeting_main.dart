import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../binding/meeting_create_bindings.dart';
import '../../controller/backios_controller.dart';
import '../../controller/meeting/meeting_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../../model/meeting.dart';
import '../widget/meeting_listview.dart';
import 'create/meeting_create.dart';

class MeetingMainPage extends GetView<MeetingController> {
  MeetingMainPage({super.key});

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
            await controller.updateMeetingList();
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
              if (controller.meetingList.value == null ||
                  controller.meetingList.value!.isEmpty) {
                return _noMeetingWidget();
              } else {
                List<Meeting> meetingList = controller.meetingList.value!;
                return MeetingListView(meetingList,
                    scrollController: controller.meetingScrollController);
              }
            }),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25.h),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => const MeetingCreate(),
                      binding: MeetingCreateBindings());
                },
                child: _newMeetingButton()),
          )
        ],
      ),
    );
  }

  Widget _head() {
    return CustomTitleBar(title: '언제보까');
  }

  Widget _noMeetingWidget() {
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
                    ImagePath.meetingEmptyTimi,
                    width: 127.w,
                    height: 131.h,
                  ),
                  Text(
                    '생성된 언제보까가 없어요.\n지금 바로 생성해보세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.black,
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

  Widget _newMeetingButton() {
    return Image.asset(
      ImagePath.makeMeetingButton,
      width: 330.w,
      height: 49.h,
    );
  }
}
