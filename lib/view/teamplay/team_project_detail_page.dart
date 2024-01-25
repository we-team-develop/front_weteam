import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/model/weteam_project_user.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:front_weteam/view/dialog/home/team_project_dialog.dart';
import 'package:front_weteam/view/widget/team_project_widget.dart';
import 'package:get/get.dart';

import '../../controller/team_project_detail_page_controller.dart';

class TeamProjectDetailPage extends GetView<TeamProjectDetailPageController> {
  final TeamProject tp;

  const TeamProjectDetailPage(this.tp, {super.key});

  @override
  StatelessElement createElement() {
    Get.put(TeamProjectDetailPageController(tp));

    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Center(
                  child: Text(
                    '팀플방',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              SizedBox(height: 15.h),
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _CustomDivider(),
                        Obx(() => TeamProjectWidget(controller.teama.value)),
                        const _CustomDivider(),

                        Obx(() {
                          if (controller.userList.value.isEmpty) {
                            return const CircularProgressIndicator();
                          } else {
                            return _UserListView();
                          }
                        }),

                        _BottomWidget(),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      color: const Color(0xFFEBE8E8),
    );
  }
}

class _UserContainer extends StatelessWidget {
  final WeteamProjectUser projectUser;

  const _UserContainer(this.projectUser);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            children: [
              Container(
                width: 48.49.w,
                height: 48.49.h,
                decoration: const ShapeDecoration(
                  color: Color(0xFFD9D9D9),
                  shape: OvalBorder(),
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                "${projectUser.user.username}",
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 10.sp,
                  fontFamily: 'NanumSquareNeo',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                projectUser.role ?? "미입력",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF676767),
                  fontSize: 9.sp,
                  fontFamily: 'NanumSquareNeo',
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        Visibility(
            visible: Get.find<TeamProjectDetailPageController>()
                    .teama.value.host.id == projectUser.user.id,
            child: Positioned(
                right: 0,
                left: 0,
                child: Image.asset(ImagePath.icSolarCrownBold,
                    width: 16.w, height: 16.h)))
      ],
    );
  }
}

class _UserListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserListViewState();
  }
}

class _UserListViewState extends State<_UserListView> {
  Rx<List<_UserContainer>> userContainerList = Rx<List<_UserContainer>>([]);

  @override
  void initState() {
    buildList();
    return super.initState();
  }

  Future<void> buildList() async {
    List<WeteamProjectUser> userList =
        Get
            .find<TeamProjectDetailPageController>()
            .userList
            .value;
    List<_UserContainer> newUserContainerList = [];
    for (WeteamProjectUser user in userList) {
      newUserContainerList.add(_UserContainer(user));
    }

    userContainerList.value = newUserContainerList;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 10.w,
          runAlignment: WrapAlignment.start,
          runSpacing: 5.h,
          children: userContainerList.value,
        ));
  }
}

class _BottomWidget extends GetView<TeamProjectDetailPageController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Visibility( // 어드민 전용 설정
            visible: controller.teama.value.host.id == Get
                .find<AuthService>()
                .user
                .value!
                .id,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '팀플방 관리실 | 호스트',
                  style: TextStyle(
                    color: const Color(0xFF333333),
                    fontSize: 14.sp,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 14.h),
                Visibility(
                    visible: controller.teama.value.done,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TextButton(text: '팀플 기간 연장 (팀플 복구)', onTap: () {}),
                      ],
                    )),
                Visibility(
                    visible: !controller.teama.value.done,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TextButton(text: '팀플 정보 수정', onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TeamProjectDialog(teamData: controller.teama.value);
                              });
                        }),
                        _TextButton(text: '강제 퇴장 시키기', onTap: () {}),
                        _TextButton(text: '호스트 권한 넘기기', onTap: () {}),
                        SizedBox(height: 23.h)
                      ],
                    )),

              ],
            )),

        Visibility( // 공통
            visible: !controller.teama.value.done,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '팀플방 관리실 | 공통',
                  style: TextStyle(
                    color: const Color(0xFF333333),
                    fontSize: 14.sp,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 14.h),
                _TextButton(text: '내 역할 변경하기', onTap: () {}),
              ],
            ))
      ],
    );
  }
}

class _TextButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  const _TextButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 9.h),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xE2333333),
            fontSize: 13.sp,
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

}