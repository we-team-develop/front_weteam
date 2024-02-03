import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../controller/notification_controller.dart';
import '../../data/color_data.dart';
import '../../model/weteam_notification.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  StatelessElement createElement() {
    Get.put(NotificationController());
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SizedBox(height: 16.h),
          const Center(
            child: Text(
              '알림',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
              child: PagedListView<int, WeteamNotification>(
            pagingController: controller.getPagingController(),
            builderDelegate: PagedChildBuilderDelegate<WeteamNotification>(
              itemBuilder: (context, item, index) =>
                  NotificationContainer(item),
              noItemsFoundIndicatorBuilder: (context) => const Center(
                child: Text(
                  "아직 받은 알림이 없어요!",
                  style: TextStyle(fontFamily: "NanumSquareNeo"),
                ),
              ),
            ),
          )),
        ],
      ),
    ));
  }
}

class NotificationContainer extends StatelessWidget {
  final WeteamNotification notification;

  const NotificationContainer(this.notification, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
      color: notification.read ? Colors.transparent : AppColors.Orange_01,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.getTitle(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontFamily: 'NanumGothic',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            notification.getContent(),
            style: TextStyle(
              color: AppColors.Black,
              fontSize: 11.sp,
              fontFamily: 'NanumGothic',
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            notification.date,
            style: TextStyle(
              color: AppColors.G_04,
              fontSize: 10.sp,
              fontFamily: 'NanumGothic',
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      ),
    );
  }
}
