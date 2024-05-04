import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:io' show Platform;

import '../../controller/alarm_controller.dart';
import '../../controller/team_project_detail_page_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../../model/weteam_alarm.dart';
import '../../service/api_service.dart';
import '../teamplay/team_project_detail_page.dart';

class AlarmListPage extends GetView<AlarmController> {
  const AlarmListPage({super.key});

  @override
  StatelessElement createElement() {
    Get.put(AlarmController());
    return super.createElement();
  }

  //ios andorid 구분
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Platform.isIOS ? iosTitle(context) : androidTitle(),
            SizedBox(height: 16.h),
            Expanded(
                child: PagedListView<int, WeteamAlarm>(
              pagingController: controller.getPagingController(),
              builderDelegate: PagedChildBuilderDelegate<WeteamAlarm>(
                itemBuilder: (context, item, index) =>
                    NotificationContainer(item),
                noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Text(
                    "아직 받은 알림이 없어요!",
                    style: TextStyle(
                        fontFamily: "NanumSquareNeo", fontSize: 12.sp),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget iosTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬을 유지
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Image.asset(ImagePath.backios), // 뒤로가기 버튼 이미지
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Expanded(
          child: Text(
            '알림',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontFamily: 'NanumGothic',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(), // 균형 유지를 위한 빈 컨테이너
      ],
    );
  }

  Widget androidTitle() {
    return Center(
      child: Text(
        '알림',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      ),
    );
  }
}

class NotificationContainer extends StatefulWidget {
  final WeteamAlarm notification;

  const NotificationContainer(this.notification, {super.key});

  @override
  State<NotificationContainer> createState() => _NotificationContainerState();
}

class _NotificationContainerState extends State<NotificationContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.find<ApiService>().readAlarm(widget.notification.id);
        if (widget.notification.project != null) {
          setState(() {
            widget.notification.read = true;
          });
          Get.to(() => GetBuilder(
              builder: (controller) => const TeamProjectDetailPage(),
              init: TeamProjectDetailPageController(
                  widget.notification.project!)));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
        color:
            widget.notification.read ? Colors.transparent : AppColors.orange1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.notification.getTitle(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              widget.notification.getContent(),
              style: TextStyle(
                color: AppColors.black,
                fontSize: 11.sp,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              widget.notification.date,
              style: TextStyle(
                color: AppColors.g4,
                fontSize: 10.sp,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
    );
  }
}
