import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/my_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/view/my/profile.dart';
import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/view/widget/app_title_widget.dart';
import 'package:front_weteam/view/widget/team_project_widget.dart';
import 'package:get/get.dart';

class MyPage extends GetView<MyController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _body(),
        )
      ],
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        _head(),
        SizedBox(height: 16.0.h),
        _profileContainer(),
        SizedBox(height: 24.h),
        _bottomContainer(),
      ],
    );
  }

  Widget _head() {
    return Padding(
        padding: EdgeInsets.only(left: 15.0.w, top: 25.0.h),
        child: const AppTitleWidget());
  }

  Widget _profileContainer() {
    return AspectRatio(
        aspectRatio: 360 / 135,
        child: Container(
          decoration: const BoxDecoration(color: Color(0xFFFFF2EF)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 37.0.w),
              Container(
                width: 82.w,
                height: 82.h,
                decoration: const ShapeDecoration(
                  color: Color(0xFFC4C4C4),
                  shape: OvalBorder(),
                ),
              ),
              SizedBox(width: 33.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${controller.getUserName()}님 ',
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 16.sp,
                          fontFamily: 'NanumGothic',
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const Profile());
                        },
                        child: Image.asset(ImagePath.icRightGray30,
                            width: 15.w, height: 15.h),
                      )
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    controller.getUserDescription(),
                    style: TextStyle(
                      color: const Color(0xFF7E7E7E),
                      fontSize: 10.sp,
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget _bottomContainer() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(left: 15.0.w, right: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bottomContainerTitle(),
          controller.hasCompletedTeamProjects()
              ? _bottomContainerTeamListWidget()
              : _bottomContainerEmpty()
        ],
      ),
    ));
  }

  Widget _bottomContainerTitle() {
    String text;

    if (controller.hasCompletedTeamProjects()) {
      text = "${controller.getUserName()}님이 완료한 팀플들이에요!";
    } else {
      text = "${controller.getUserName()}님은 완료한 팀플이 없어요!";
    }

    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF333333),
        fontSize: 14.sp,
        fontFamily: 'NanumGothic',
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _bottomContainerTeamListWidget() {
    List<Widget> list = [];

    TeamProject tp = const TeamProject(
        title: '앱디져🔥🔥🔥',
        description: '앱디자인 강의 패러디앱 디자인 제작',
        memberSize: 3,
        date: '2023.01.02~ 2023.06.31');

    TeamProjectWidget tpw = TeamProjectWidget(tp);

    for (int i = 0; i < 20; i++) {
      list.add(tpw);
    }

    return Column(
      children: [
        // 예시입니다
        SizedBox(height: 24.h),
        ...list
      ],
    );
  }

  Widget _bottomContainerEmpty() {
    return Expanded(
        child: Center(
            child: Image.asset(
      ImagePath.myNoTeamProjectTimi,
      width: 113.37.w,
      height: 171.44.h,
    )));
  }
}
