import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/mainpage/my_page_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../../main.dart';
import '../../model/team_project.dart';
import '../../model/weteam_user.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../widget/app_title_widget.dart';
import '../widget/profile_image_widget.dart';
import '../widget/team_project_widget.dart';
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
  void initState() {
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
      String? json = sharedPreferences
          .getString(SharedPreferencesKeys.teamProjectDoneListJson);
      if (json != null) {
        tpList.value =
            GetTeamProjectListResult.fromJson(jsonDecode(json)).projectList;
        _oldTpList = tpList.value;
      }

      result = await Get.find<ApiService>().getTeamProjectList(
          0, true, 'DESC', 'DONE', widget.user.value!.id,
          cacheKey: SharedPreferencesKeys.teamProjectDoneListJson);
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
    return RefreshIndicator(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics()),
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
                sliver: (tpList.value.isNotEmpty)
                    ? _teamProjectList()
                    : _noTeamProject())
          ],
        ),
        onRefresh: () async {
          await updateTeamProjectLists();
        });
  }

  Widget _head() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0.w, top: 25.0.h),
      child: CustomAppTitleBar(title: 'WETEAM'),
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
                      color: AppColors.black,
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
                      color: AppColors.g4,
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
      childCount: tpList.value.length + 1,
      (context, index) {
        if (index == 0) {
          return SizedBox(height: 24.h);
        }
        return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: TeamProjectWidget(tpList.value[index - 1]));
      },
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
          color: AppColors.black,
          fontSize: 14.sp,
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.w600,
        ),
      );
    });
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
