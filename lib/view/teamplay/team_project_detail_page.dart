import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/home_controller.dart';
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
import '../widget/profile_image_widget.dart';

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
                    Obx(() => Stack(children: [
                          TeamProjectWidget(controller.tp.value),
                          (controller.tp.value.memberSize == 1 ||
                                  controller.tp.value.host.id !=
                                      Get.find<AuthService>().user.value!.id)
                              ? Positioned(
                            top: 0,
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  exitOrDeleteTeamProject();
                                },
                                child: Image.asset(ImagePath.icHostoutGray,
                                    width: 21.w, height: 21.h)
                                ,
                              )                          )
                              : const SizedBox(),
                        ])),
                    const _CustomDivider(),
                    Obx(() {
                      if (controller.userList.isEmpty) {
                        return const CircularProgressIndicator();
                      } else {
                        return _UserListView();
                      }
                    }),
                    Obx(() => Visibility(
                        visible: controller.isKickMode.isFalse &&
                            controller.isChangeHostMode.isFalse,
                        child: _BottomWidget())),
                    Obx(() => Visibility(
                        visible: controller.isKickMode.isTrue,
                        child: _CancelOrActionBottomPanel(
                            message: '강제 퇴장 시킬 팀원을 선택하고 있습니다.',
                            actionButtonText: '퇴출하기',
                            action: kickAll,
                            cancelAction: () =>
                                controller.isKickMode.value = false))),
                    Obx(() => Visibility(
                        visible: controller.isChangeHostMode.isTrue,
                        child: _CancelOrActionBottomPanel(
                            message: '호스트 권한을 넘기고 있습니다.',
                            actionButtonText: '호스트넘기기',
                            action: changeHost,
                            cancelAction: () =>
                                controller.isChangeHostMode.value = false)))
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> exitOrDeleteTeamProject() async {
    if (tp.host.id == Get.find<AuthService>().user.value!.id) {
      bool success = await Get.find<ApiService>().deleteTeamProject(tp.id);
      if (success) {
        await Get.find<HomeController>().updateTeamProjectList();
        Get.back();
        Get.snackbar("삭제 성공", '팀플이 성공적으로 삭제되었어요.');
      } else {
        Get.snackbar("삭제 실패", '팀플을 삭제하지 못했어요.');
      }
    } else {
      throw UnimplementedError(); // 나가기 기능
    }
  }

  Future<void> changeHost() async {
    if (controller.selectedNewHost.value == -1) {
      Get.snackbar("호스트 권한을 넘길 수 없습니다", '호스트 권한을 받을 유저를 선택해주세요');
      return;
    }

    bool success = await Get.find<ApiService>()
        .changeTeamProjectHost(tp.id, controller.selectedNewHost.value);
    if (success) {
      await Get.find<HomeController>().updateTeamProjectList();
      controller.isChangeHostMode.value = false;
      Get.back();
      Get.snackbar("호스트 변경 성공", "호스트 권한을 성공적으로 넘겼습니다");
    } else {
      Get.snackbar("호스트 변경 실패", "오류가 발생했습니다");
    }
  }

  Future<void> kickAll() async {
    ApiService service = Get.find<ApiService>();
    List<int> toKickIds = [];
    for (Widget widget in controller.userContainerList) {
      _UserContainer uc = widget as _UserContainer;
      if (uc.kickSelected.isTrue) {
        toKickIds.add(uc.projectUser.id);
      }
    }

    bool success = await service.kickUserFromTeamProject(toKickIds);

    if (success) {
      Get.snackbar("강제 퇴장 성공", "총 ${toKickIds.length}명을 강제 퇴장했어요");
      controller.fetchUserList();
      controller.isKickMode.value = false;
    } else {
      Get.snackbar("강제 퇴장 실패", "오류가 발생했습니다");
    }
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
                SizedBox(
                  width: 48.49.w,
                  height: 48.49.h,
                  child: ProfileImageWidget(
                      id: projectUser.user.profile?.imageIdx ?? 0),
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
              ))),
          Obx(() => Visibility(
                visible: controller.isChangeHostMode.value && !amIOwner(),
                child: Positioned(
                  top: 25.h,
                  left: 10.w,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      controller.selectedNewHost.value = projectUser.user.id;
                    },
                    child: Container(
                      width: 55.w,
                      height: 20.h,
                      decoration: ShapeDecoration(
                        color: controller.selectedNewHost.value ==
                                projectUser.user.id
                            ? const Color(0xFFEB8673)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '호스트 넘기기',
                          style: TextStyle(
                            color: controller.selectedNewHost.value ==
                                    projectUser.user.id
                                ? Colors.white
                                : const Color(0xFF333333),
                            fontSize: 8.sp,
                            fontFamily: 'NanumSquareNeo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
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
                        _TextButton(
                            text: '호스트 권한 넘기기',
                            onTap: () {
                              if (controller.tp.value.memberSize == 1) {
                                Get.snackbar("", '호스트를 넘겨 받을 팀원이 없습니다');
                                return;
                              }
                              controller.isKickMode.value = false;
                              controller.isChangeHostMode.value = true;
                            }),
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

class _CancelOrActionBottomPanel
    extends GetView<TeamProjectDetailPageController> {
  final String message;
  final String actionButtonText;
  final Function() action;
  final Function() cancelAction;
  bool isKicking = false;

  _CancelOrActionBottomPanel(
      {required this.message,
      required this.actionButtonText,
      required this.cancelAction,
      required this.action});

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
                onTap: cancelAction,
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
                  dynamic ret = action.call();
                  if (ret is Future) await ret;
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
