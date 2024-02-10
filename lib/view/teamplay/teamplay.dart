import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/tp_controller.dart';
import '../../data/color_data.dart';
import '../../data/image_data.dart';
import '../../model/team_project.dart';
import '../widget/app_title_widget.dart';
import '../widget/team_project_column.dart';

class TeamPlay extends GetView<TeamPlayController> {
  const TeamPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w, top: 25.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppTitleWidget(),
          SizedBox(
            height: 22.0.h,
          ),
          Text(
            '${controller.getUserName()}님이 진행중이신 팀플이에요!',
            style: TextStyle(
                fontFamily: 'NanumGothic',
                fontSize: 14.0.sp,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 11.0,
          ),
          Image.asset(
            ImagePath.tpBanner,
            width: 330.w,
            height: 205.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 24.0.h,
          ),
          Expanded(
            child: Obx(() {
              if (controller.tpList.value == null ||
                  controller.tpList.value!.projectList.isEmpty) {
                return _noTeamProject();
              } else {
                List<TeamProject> tpList = controller.tpList.value!.projectList;
                return TeamProjectListView(tpList);
              }
            }),
          )
        ],
      ),
    );
  }

  Widget _noTeamProject() {
    return const Center(
        child: Text(
          '진행 중인  팀플이 없어요.\n홈화면에서 팀플을 생성해보세요!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.Black,
            fontSize: 11,
            fontFamily: 'NanumSquareNeo',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ));
  }
}
