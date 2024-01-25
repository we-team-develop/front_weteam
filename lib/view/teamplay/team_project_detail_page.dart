import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/model/weteam_project_user.dart';
import 'package:front_weteam/service/api_service.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:front_weteam/view/dialog/custom_big_dialog.dart';
import 'package:front_weteam/view/dialog/home/team_project_dialog.dart';
import 'package:front_weteam/view/widget/team_project_widget.dart';
import 'package:get/get.dart';

import '../../controller/team_project_detail_page_controller.dart';
import '../widget/custom_text_field.dart';

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
                    Obx(() => TeamProjectWidget(controller.tp.value)),
                    const _CustomDivider(),
                    Obx(() {
                      if (controller.userList.isEmpty) {
                        return const CircularProgressIndicator();
                      } else {
                        return _UserListView();
                      }
                    }),
                    Obx(() => Visibility(
                        visible: controller.isKickMode.isFalse,
                        child: _BottomWidget())),
                    Obx(() => Visibility(
                        visible: controller.isKickMode.isTrue,
                        child: _KickModeBottomPanel())),
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

class _UserContainer extends GetView<TeamProjectDetailPageController> {
  final WeteamProjectUser projectUser;
  final RxBool kickSelected = RxBool(false);

  _UserContainer(this.projectUser) {
    controller.isKickMode.listen((p0) {
      if (!p0) {
        kickSelected.value = false; // 강퇴모드 꺼지면 선택 해제
      }
    });
  }

  bool amIOwner() {
    return controller.tp.value.host.id == projectUser.user.id;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (controller.isKickMode.isTrue && !amIOwner()) {
          kickSelected.value = !kickSelected.value;
        }
      },
      child: Stack(
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
              visible: amIOwner(),
              child: Positioned(
                  right: 0,
                  left: 0,
                  child: Image.asset(ImagePath.icSolarCrownBold,
                      width: 16.w, height: 16.h))),
          Obx(() => Visibility(
              visible: controller.isKickMode.value && !amIOwner(),
              child: Positioned(
                right: 10.w,
                top: 10.h,
                child: kickSelected.value
                    ? Image.asset(ImagePath.icCheckWhiteActivated,
                        width: 14.w, height: 14.h)
                    : Image.asset(ImagePath.icCheckWhite,
                        width: 14.w, height: 14.h),
              )))
        ],
      ),
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
  late TeamProjectDetailPageController controller;

  @override
  void initState() {
    controller = Get.find<TeamProjectDetailPageController>();
    buildList();
    Get.find<TeamProjectDetailPageController>().userList.listen((p0) {
      buildList();
    });
    return super.initState();
  }

  Future<void> buildList() async {
    controller.userContainerList.clear();

    List<WeteamProjectUser> userList =
        Get.find<TeamProjectDetailPageController>().userList;
    List<_UserContainer> newUserContainerList = [];
    for (WeteamProjectUser user in userList) {
      newUserContainerList.add(_UserContainer(user));
    }

    controller.userContainerList.addAll(newUserContainerList);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 10.w,
      runAlignment: WrapAlignment.start,
      runSpacing: 5.h,
      children: controller.userContainerList,
    );
  }
}

class _BottomWidget extends GetView<TeamProjectDetailPageController> {
  TextEditingController changeRoleTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            // 어드민 전용 설정
            visible: controller.tp.value.host.id ==
                Get.find<AuthService>().user.value!.id,
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
                    visible: controller.tp.value.done,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TextButton(text: '팀플 기간 연장 (팀플 복구)', onTap: () {}),
                      ],
                    )),
                Visibility(
                    visible: !controller.tp.value.done,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TextButton(
                            text: '팀플 정보 수정',
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TeamProjectDialog(
                                        teamData: controller.tp.value);
                                  });
                            }),
                        _TextButton(
                            text: '강제 퇴장 시키기',
                            onTap: () {
                              if (controller.tp.value.memberSize == 1) {
                                Get.snackbar("", '강제 퇴장할 팀원이 없습니다');
                                return;
                              }
                              controller.isKickMode.value =
                                  !controller.isKickMode.value;
                            }),
                        _TextButton(text: '호스트 권한 넘기기', onTap: () {}),
                        SizedBox(height: 23.h)
                      ],
                    )),
              ],
            )),
        Visibility(
            // 공통
            visible: !controller.tp.value.done,
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
                _TextButton(
                    text: '내 역할 변경하기',
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomBigDialog(
                                title: '내 역할 변경',
                                child: _ChangeRoleDialog(changeRoleTEC));
                          });
                    }),
              ],
            ))
      ],
    );
  }
}

class _KickModeBottomPanel extends GetView<TeamProjectDetailPageController> {
  bool isKicking = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '강제 퇴장 시킬 팀원을 선택하고 있습니다.',
          style: TextStyle(
            color: const Color(0xFF333333),
            fontSize: 10.sp,
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.isKickMode.value = false;
                },
                child: Container(
                  height: 38.h,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '취소',
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 12.sp,
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
                child: GestureDetector(
              onTap: () async {
                if (isKicking) return;
                isKicking = true;
                try {
                  await kickAll();
                } catch (e, st) {
                  Get.snackbar("죄송합니다", "오류가 발생했습니다");
                  debugPrint("$e");
                  debugPrintStack(stackTrace: st);
                }
                isKicking = false;
              },
              child: Container(
                height: 38.h,
                decoration: ShapeDecoration(
                  color: const Color(0xFFE2583E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Center(
                  child: Text(
                    '퇴출하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            )),
          ],
        )
      ],
    );
  }

  Future<void> kickAll() async {
    ApiService service = Get.find<ApiService>();
    List<Future> results = [];
    for (Widget widget in controller.userContainerList) {
      _UserContainer uc = widget as _UserContainer;
      if (uc.kickSelected.isTrue) {
        results.add(service.kickUserFromTeamProject(uc.projectUser.id));
      }
    }

    int success = 0;
    for (Future result in results) {
      if (await result == true) success++;
    }

    Get.snackbar("$success명을 성공적으로 강제 퇴장했어요", "총 ${results.length} 명 중");
    controller.fetchUserList();
    controller.isKickMode.value = false;
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

class _ChangeRoleDialog extends GetView<TeamProjectDetailPageController> {
  final TextEditingController tec;

  const _ChangeRoleDialog(this.tec);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(hint: "역할명", maxLength: 10, controller: tec),
        SizedBox(height: 35.h),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            bool result = await Get.find<ApiService>()
                .changeUserTeamProjectRole(controller.tp.value, tec.text);
            ;
            if (result) {
              Get.back();
              controller.fetchUserList();
            } else {
              Get.snackbar("죄송합니다", "역할을 설정하지 못했습니다");
            }
          },
          child: Container(
            width: 185.w,
            height: 32.h,
            decoration: ShapeDecoration(
              color: const Color(0xFFE2583E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Center(
              child: Text(
                '확인',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
