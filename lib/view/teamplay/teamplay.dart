import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import '../../controller/mainpage/tp_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../widget/app_title_widget.dart';
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
      padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w, top: 25.0.h),
      child: RefreshIndicator(
          onRefresh: () async {
            await controller.updateTeamProjectList();
          },
          child: Obx(() => CustomScrollView(
                controller: controller.tpScrollController,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics()),
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    CustomAppTitleBar(title: 'WETEAM'),
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
                      controller.tpList.value!.projectList.isEmpty)
                    _noTeamProject()
                  else
                    _teamProjectList(tpPadding)
                ],
              ))),
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
      childCount: controller.tpList.value!.projectList.length,
      (context, index) => Padding(
          padding: padding,
          child:
              TeamProjectWidget(controller.tpList.value!.projectList[index])),
    ));
  }
}

class CustomAppTitleBar extends StatelessWidget {
  final String title;

  CustomAppTitleBar({required this.title});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // iOS: 중앙 정렬 + 뒤로 가기 버튼
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (Platform.isIOS)
            Container(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  ImagePath.backios,
                  width: 30.w,
                  height: 30.h,
                ),
              ),
            ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontFamily: 'SBaggroB',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (Platform.isIOS)
            SizedBox(
              width: 30.w,
              height: 30.h,
            ), // 균형을 맞추기 위한 빈 박스
        ],
      );
    } else {
      // Android: 왼쪽 정렬
      return Text(
        'WE TEAM',
        textAlign: TextAlign.left,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 16.sp,
          fontFamily: 'SBaggroB',
          fontWeight: FontWeight.w400,
          height: 0,
        ),
      );
    }
  }
}
