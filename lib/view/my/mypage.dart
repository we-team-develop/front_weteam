
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/mainpage/my_page_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../widget/custom_title_bar.dart';
import '../widget/profile_image_widget.dart';
import '../widget/team_project_widget.dart';
import 'profile.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UserInfoPage(Get.find<MyInfoController>());
  }
}

class UserInfoPage extends StatefulWidget {
  final UserInfoController controller;

  const UserInfoPage(this.controller, {super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late UserInfoController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return RefreshIndicator(
        child: Obx(() => CustomScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
                  _head(),
                  SizedBox(height: 16.0.h),
                  _profileContainer(),
                  SizedBox(height: 24.h),
                ])),
            SliverPadding(
                padding: EdgeInsets.only(left: 15.0.w, right: 16.0.w),
                sliver: SliverToBoxAdapter(
                  child: _bottomContainerTitle(),
                )),
            SliverPadding(
                padding: EdgeInsets.only(left: 15.0.w, right: 16.0.w),
                sliver: (controller.rxTpList.isNotEmpty)
                    ? _teamProjectList()
                    : _noTeamProject())
          ],
        )),
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          await controller.updateTeamProjectList();
        });
  }

  Widget _head() {
    return Padding(
      padding: EdgeInsets.only(top: 25.0.h),
      child: CustomTitleBar(
          useNavController: !controller.isOtherUser(), strongFont: true),
    );
  }

  Widget _profileContainer() {
    return Container(
      width: 360.w,
      height: 135.h,
      decoration: const BoxDecoration(color: AppColors.orange1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 37.0.w),
          Obx(() => ProfileImageWidget(
              id: controller.user.value?.profile?.imageIdx ?? 0)),
          SizedBox(width: 33.w),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => const Profile());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        child: Text(
                      '${controller.user.value?.username}님 ',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16.sp,
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        height: 1,
                      ),
                    )),
                    Visibility(
                        visible: !controller.isOtherUser(),
                        child: Image.asset(ImagePath.icRightGray30,
                            width: 15.w, height: 15.h))
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Obx(() => Text(
                    controller.user.value?.organization ?? '미입력',
                    style: TextStyle(
                      color: AppColors.g4,
                      fontSize: 12.sp,
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.w400,
                    ),
                  )),
            ],
          ))
        ],
      ),
    );
  }

  Widget _noTeamProject() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 88.h),
        child: Center(
          child: Image.asset(
            ImagePath.myNoTeamProjectTimi,
            width: 165.37.w,
            height: 171.44.h,
          ),
        ),
      ),
    );
  }

  Widget _teamProjectList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      childCount: controller.rxTpList.length + 1,
      (context, index) {
        if (index == 0) {
          return SizedBox(height: 24.h);
        }
        return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: TeamProjectWidget(controller.rxTpList[index - 1]));
      },
    ));
  }

  Widget _bottomContainerTitle() {
    return Obx(() {
      String text;

      String? userName = controller.user.value?.username;
      if (controller.rxTpList.isNotEmpty) {
        text = "$userName님이 완료한 팀플들이에요!";
      } else {
        text = "$userName님은 완료한 팀플이 없어요!";
      }

      return Text(
        text,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 14.sp,
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.w600,
        ),
      );
    });
  }
}
