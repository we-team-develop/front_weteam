import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/my_page_controller.dart';
import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/model/weteam_user.dart';
import 'package:get/get.dart';

import '../../data/color_data.dart';
import '../../data/image_data.dart';
import '../../main.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../widget/app_title_widget.dart';
import '../widget/profile_image_widget.dart';
import '../widget/team_project_column.dart';
import 'profile.dart';

class MyPage extends GetView<MyPageController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UserInfoPage(
        user: Get.find<AuthService>().user,
        isOtherUser: false,
        scrollController: controller.scrollController);
  }
}

class UserInfoPage extends StatefulWidget {
  final ScrollController? scrollController;
  final Rxn<WeteamUser> user;
  final bool isOtherUser;

  const UserInfoPage(
      {super.key,
      required this.user,
      required this.isOtherUser,
      this.scrollController});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final Rx<List<TeamProject>> tpList = Rx<List<TeamProject>>([]);
  List<TeamProject> _oldTpList = [];

  @override
  void initState () {
    fetchTeamProjectList();
    if (!widget.isOtherUser) {
      tpListUpdateRequiredListenerList.add(fetchTeamProjectList);
    }
    return super.initState();
  }

  Future<void> fetchTeamProjectList() async {
    GetTeamProjectListResult? result;

    if (widget.isOtherUser) {
      result = await Get.find<ApiService>()
          .getTeamProjectList(0, true, 'DESC', 'DONE', widget.user.value!.id);
    } else {
      String? json = sharedPreferences.getString(
          SharedPreferencesKeys.teamProjectDoneListJson);
      if (json != null) {
        tpList.value = GetTeamProjectListResult.fromJson(jsonDecode(json)).projectList;
        _oldTpList = tpList.value;
      }

      result = await Get.find<ApiService>()
          .getTeamProjectList(0, true, 'DESC', 'DONE', widget.user.value!.id,
          cacheKey: SharedPreferencesKeys
              .teamProjectDoneListJson);
    }

    if (result != null && !listEquals(result.projectList, _oldTpList)) {
      _oldTpList = tpList.value;
      tpList.value = result.projectList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _body(),
    ));
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
    return Container(
      width: 360.w,
      height: 135.h,
      decoration: const BoxDecoration(color: AppColors.Orange_01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 37.0.w),
          Obx(() => ProfileImageWidget(
              id: widget.user.value?.profile?.imageIdx ?? 0)),
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
                            '${widget.user.value!.username}님 ',
                            style: TextStyle(
                              color: AppColors.Black,
                              fontSize: 16.sp,
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              height: 1,
                            ),
                          )),
                      Visibility(
                          visible: !widget.isOtherUser,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => const Profile());
                            },
                            child: Image.asset(ImagePath.icRightGray30,
                                width: 15.w, height: 15.h),
                          ))
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Obx(() => Text(
                    widget.user.value?.organization ?? '미입력',
                    style: TextStyle(
                      color: AppColors.G_04,
                      fontSize: 10.sp,
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

  Widget _bottomContainer() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(left: 15.0.w, right: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bottomContainerTitle(),
          Expanded(child: Obx(() {
            if (tpList.value.isNotEmpty) {
              return _bottomContainerTeamListWidget();
            } else {
              return _bottomContainerEmpty();
            }
          })),
        ],
      ),
    ));
  }

  Widget _bottomContainerTitle() {
    return Obx(() {
      String text;

      if (tpList.value.isNotEmpty) {
        text = "${widget.user.value?.username}님이 완료한 팀플들이에요!";
      } else {
        text = "${widget.user.value?.username}님은 완료한 팀플이 없어요!";
      }

      return Text(
        text,
        style: TextStyle(
          color: AppColors.Black,
          fontSize: 14.sp,
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.w600,
        ),
      );
    });
  }

  Widget _bottomContainerTeamListWidget() {
    return Column(
      children: [
        SizedBox(height: 24.h),
        Expanded(child: TeamProjectListView(tpList.value, scrollController: widget.scrollController))
      ],
    );
  }

  Widget _bottomContainerEmpty() {
    return Center(
        child: Image.asset(
          ImagePath.myNoTeamProjectTimi,
          width: 113.37.w,
          height: 171.44.h,
        ));
  }
}
