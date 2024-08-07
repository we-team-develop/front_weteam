import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../controller/alarm_controller.dart';
import '../../controller/team_project_detail_page_controller.dart';
import '../../data/app_colors.dart';
import '../../model/weteam_alarm.dart';
import '../../service/team_project_service.dart';
import '../../util/weteam_utils.dart';
import '../teamplay/team_project_detail_page.dart';
import '../widget/custom_title_bar.dart';

class AlarmListPage extends GetView<AlarmController> {
  const AlarmListPage({super.key});

  @override
  StatelessElement createElement() {
    Get.put(AlarmController());
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            const CustomTitleBar(title: '알림'),
            SizedBox(height: 16.h),
            Expanded(
                child: PagedListView<int, WeteamAlarm>(
              pagingController: controller.getPagingController(),
              builderDelegate: PagedChildBuilderDelegate<WeteamAlarm>(
                itemBuilder: (context, item, index) =>
                    AlarmContainer(item),
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
}

class AlarmContainer extends StatefulWidget {
  final WeteamAlarm notification;

  const AlarmContainer(this.notification, {super.key});

  @override
  State<AlarmContainer> createState() => _AlarmContainerState();
}

class _AlarmContainerState extends State<AlarmContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        RxTeamProject? rxProject = widget.notification.rxProject;
        if (rxProject != null) {
          setState(() {
            widget.notification.read = true;
          });

          TeamProjectService tpService = Get.find<TeamProjectService>();
          if (tpService.getTeamProjectById(rxProject.value.id) == null) {
            WeteamUtils.snackbar('', '탈퇴한 팀플입니다.', icon: SnackbarIcon.info);
            return;
          }
          Get.to(() => GetBuilder(
              builder: (controller) => const TeamProjectDetailPage(),
              init: TeamProjectDetailPageController(
                  widget.notification.rxProject!)));
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
