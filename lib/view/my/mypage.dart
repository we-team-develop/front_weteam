import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/my_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:front_weteam/view/my/profile.dart';
import 'package:front_weteam/view/widget/app_title_widget.dart';
import 'package:front_weteam/view/widget/profile_image_widget.dart';
import 'package:front_weteam/view/widget/team_project_widget.dart';
import 'package:get/get.dart';

class MyPage extends GetView<MyController> {
  const MyPage({super.key});

  @override
  StatelessElement createElement() {
    Get.put(MyController());
    return super.createElement();
  }

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
              Obx(() => ProfileImageWidget(
                  id: Get.find<AuthService>().user.value?.profile ?? 0)),
              SizedBox(width: 33.w),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: Text(
                        '${controller.getUserName()}님 ',
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 16.sp,
                          fontFamily: 'NanumGothic',
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                          height: 1,
                        ),
                      )),
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
                  Obx(() => Text(
                        Get.find<AuthService>().user.value?.organization ??
                            '미입력',
                        style: TextStyle(
                          color: const Color(0xFF7E7E7E),
                          fontSize: 10.sp,
                          fontFamily: 'NanumGothic',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                ],
              ))
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
          Obx(() {
            if (controller.tpList.value != null &&
                controller.tpList.value!.projectList.isNotEmpty) {
              return _bottomContainerTeamListWidget();
            } else {
              return _bottomContainerEmpty();
            }
          }),
        ],
      ),
    ));
  }

  Widget _bottomContainerTitle() {
    return Obx(() {
      String text;

      if (controller.tpList.value != null &&
          controller.tpList.value!.projectList.isNotEmpty) {
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
    });
  }

  Widget _bottomContainerTeamListWidget() {
    List tpList = controller.tpList.value!.projectList;
    List<Widget> list = [];

    for (int i = 0; i < tpList.length; i++) {
      list.add(TeamProjectWidget(tpList[i]));
    }

    return Column(
      children: [SizedBox(height: 24.h), ...list],
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
