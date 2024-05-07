import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/mainpage/tp_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../widget/custom_title_bar.dart';
import '../widget/team_project_widget.dart';

class TeamPlay extends GetView<TeamPlayController> {
  const TeamPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    EdgeInsets tpPadding = EdgeInsets.only(bottom: 12.h);

    return Padding(
      padding: EdgeInsets.only(top: 25.0.h),
      child: RefreshIndicator(
          onRefresh: () async {
            HapticFeedback.mediumImpact();
            await controller.updateTeamProjectList();
          },
          child: Column(
            children: [
              const CustomTitleBar(strongFont: true, useNavController: true),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 25.h),
                child: Obx(() => CustomScrollView(
                      controller: controller.tpScrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverList(
                            delegate: SliverChildListDelegate([
                          SizedBox(height: 22.0.h),
                          Text(
                            '${controller.getUserName()}님이 진행중이신 팀플이에요!',
                            style: TextStyle(
                                fontFamily: 'NanumGothic',
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 11.0),
                          // TODO : 배너 이미지
                          Image.asset(
                            ImagePath.tpBanner,
                            width: 330.w,
                            height: 205.h,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 24.0.h),
                        ])),
                        if (controller.tpList.value == null ||
                            controller.tpList.value!.rxProjectList.isEmpty)
                          _noTeamProject()
                        else
                          _teamProjectList(tpPadding)
                      ],
                    )),
              ))
            ],
          )),
    );
  }

  Widget _noTeamProject() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
          child: Text(
        '진행 중인 팀플이 없어요.\n홈화면에서 팀플을 생성해보세요!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 11.sp,
          fontFamily: 'NanumSquareNeo',
          fontWeight: FontWeight.w400,
          height: 0,
        ),
      )),
    );
  }

  Widget _teamProjectList(EdgeInsets padding) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      childCount: controller.tpList.value!.rxProjectList.length,
      (context, index) => Padding(
          padding: padding,
          child:
              TeamProjectWidget(controller.tpList.value!.rxProjectList[index])),
    ));
  }
}
