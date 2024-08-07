import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/mainpage/tp_controller.dart';
import '../../controller/team_project_detail_page_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../../model/team_project.dart';
import '../../service/team_project_service.dart';
import '../teamplay/team_project_detail_page.dart';

class TeamProjectWidget extends StatelessWidget {
  final RxTeamProject rxTeam;

  const TeamProjectWidget(this.rxTeam, {super.key});

  @override
  Widget build(BuildContext context) {
    if (rxTeam.isDestroyed()) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => Get.to(() => GetBuilder(
          builder: (controller) => const TeamProjectDetailPage(),
          init: TeamProjectDetailPageController(rxTeam))),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 53.h,
        child: Obx(() {
          TeamProject team = rxTeam.value;
          return Column(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      _teamImgWidget(),
                      SizedBox(width: 16.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _teamTitleWidget(team.title),
                              SizedBox(width: 8.w),
                              _teamMemberCountWidget(team.memberSize),
                            ],
                          ),
                          _teamDescriptionWidget(team.description),
                          _dateWidget()
                        ],
                      )
                    ],
                  )),
            ],
          );
        }),
      ),
    );
  }

  Widget _teamImgWidget() {
    TeamPlayController controller = Get.find<TeamPlayController>();
    String imagePath = controller.imagePaths[rxTeam.value.imageId];

    return SizedBox(
      width: 50.w,
      height: 50.h,
      child: Image.asset(imagePath),
    );
  }

  Widget _teamTitleWidget(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 12.sp,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w700,
        height: 0,
      ),
    );
  }

  Widget _teamDescriptionWidget(String desc) {
    return Text(
      desc,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 9.sp,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

  Widget _teamMemberCountWidget(int memberSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      textBaseline: TextBaseline.ideographic,
      children: [
        Image.asset(width: 6.w, height: 8.h, ImagePath.icGroup),
        SizedBox(width: 2.w),
        Text(
          "$memberSize",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 9.sp,
            fontFamily: 'NanumSquareNeo',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _dateWidget() {
    return Text(
      "${_formattedDateTime(rxTeam.value.startedAt)} ~ ${_formattedDateTime(rxTeam.value.endedAt)}",
      style: TextStyle(
        color: AppColors.g4,
        fontSize: 9.sp,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

  String _formattedDateTime(DateTime dt) {
    return "${dt.year}.${dt.month}.${dt.day}";
  }
}
