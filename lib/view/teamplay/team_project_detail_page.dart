import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show Platform;

import '../../controller/team_project_detail_page_controller.dart';
import '../../data/app_colors.dart';
import '../../data/image_data.dart';
import '../../main.dart';
import '../../model/weteam_project_user.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../util/weteam_utils.dart';
import '../dialog/custom_big_dialog.dart';
import '../dialog/custom_check_dialog.dart';
import '../dialog/home/team_project_dialog.dart';
import '../my/mypage.dart';
import '../widget/custom_text_field.dart';
import '../widget/normal_button.dart';
import '../widget/profile_image_widget.dart';
import '../widget/team_project_widget.dart';

class TeamProjectDetailPage extends GetView<TeamProjectDetailPageController> {
  const TeamProjectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Platform.isIOS ? iosTitle(context) : androidTitle(),
              SizedBox(height: 15.h),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CustomDivider(),
                    Obx(() => Stack(children: [
                          TeamProjectWidget(controller.tp.value),
                          Positioned(
                              top: 0,
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  if (controller.tp.value.memberSize > 1 &&
                                      controller.tp.value.host.id ==
                                          Get.find<AuthService>()
                                              .user
                                              .value!
                                              .id) {
                                    WeteamUtils.snackbar(
                                        '', '호스트 권한을 넘겨야 방에서 나갈 수 있습니다!',
                                        icon: SnackbarIcon.fail);
                                    return;
                                  }
                                  showDialog(
                                      context: context,
                                      builder: (context) => CustomCheckDialog(
                                          title: '정말 나가시겠습니까?',
                                          content: '팀플 목록에서 완전히 삭제됩니다.',
                                          admitName: '나가기',
                                          denyName: '아니요',
                                          denyCallback: () => Get.back(),
                                          admitCallback:
                                              exitOrDeleteTeamProject));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 14.h),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          controller.tp.value.host.id ==
                                                  Get.find<AuthService>()
                                                      .user
                                                      .value!
                                                      .id
                                              ? ImagePath.icHostOutGray
                                              : ImagePath.icGuestOutGray,
                                          width: 21.w,
                                          height: 21.h),
                                      Text(
                                        '나가기',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.sp,
                                            color:
                                                controller.tp.value.host.id ==
                                                        Get.find<AuthService>()
                                                            .user
                                                            .value!
                                                            .id
                                                    ? AppColors.g3
                                                    : AppColors.g5),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
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
                            action: controller.showKickDialog,
                            cancelAction: () =>
                                controller.isKickMode.value = false))),
                    Obx(() => Visibility(
                        visible: controller.isChangeHostMode.isTrue,
                        child: _CancelOrActionBottomPanel(
                            message: '호스트 권한을 넘기고 있습니다.',
                            actionButtonText: '호스트넘기기',
                            action: controller.showChangeHostDialog,
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

  Widget iosTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬을 유지
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Image.asset(ImagePath.backios), // 뒤로가기 버튼 이미지
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Expanded(
          child: Text(
            '팀플방',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontFamily: 'NanumGothic',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(), // 균형 유지를 위한 빈 컨테이너
      ],
    );
  }

  Widget androidTitle() {
    return Center(
      child: Text(
        '팀플방',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      ),
    );
  }

  Future<void> exitOrDeleteTeamProject() async {
    if (controller.tp.value.host.id == Get.find<AuthService>().user.value!.id) {
      // 팀플 삭제
      bool success = await Get.find<ApiService>()
          .deleteTeamProject(controller.tp.value.id);
      if (success) {
        await updateTeamProjectLists();
        await WeteamUtils.closeSnackbarNow();
        Get.back();
        Get.back();
        WeteamUtils.snackbar("", '팀플이 성공적으로 삭제되었어요',
            icon: SnackbarIcon.success);
      } else {
        WeteamUtils.snackbar("", '팀플을 삭제하지 못했어요', icon: SnackbarIcon.fail);
      }
    } else {
      // 팀플 탈퇴
      bool success =
          await Get.find<ApiService>().exitTeamProject(controller.tp.value.id);
      if (success) {
        await updateTeamProjectLists();
        await WeteamUtils.closeSnackbarNow();
        Get.back();
        Get.back();
        WeteamUtils.snackbar("", '팀플을 탈퇴했어요', icon: SnackbarIcon.success);
      } else {
        WeteamUtils.snackbar("", '팀플을 탈퇴하지 못했어요', icon: SnackbarIcon.fail);
      }
    }
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.h,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      color: AppColors.g1,
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
    controller.selectedKickUser.listen((p0) {
      if (p0?.id != projectUser.id) kickSelected.value = false;
    });
  }

  bool amIHost() {
    return controller.tp.value.host.id == projectUser.user.id;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (controller.isKickMode.isTrue && !amIHost()) {
          kickSelected.value = !kickSelected.value;
          controller.selectedKickUser.value =
              kickSelected.value ? projectUser : null;
        }

        if (controller.isKickMode.isFalse &&
            controller.isChangeHostMode.isFalse) {
          if (projectUser.user.id != Get.find<AuthService>().user.value?.id) {
            Get.to(() =>
                UserInfoPage(user: Rxn(projectUser.user), isOtherUser: true));
          }
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
                    color: AppColors.black,
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
                    color: AppColors.g5,
                    fontSize: 9.sp,
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          Visibility(
              visible: amIHost(),
              child: Positioned(
                  right: 0,
                  left: 0,
                  child: Image.asset(ImagePath.icSolarCrownBold,
                      width: 16.w, height: 16.h))),
          Obx(() => Visibility(
              visible: controller.isKickMode.value && !amIHost(),
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
                visible: controller.isChangeHostMode.value && !amIHost(),
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
                            ? AppColors.orange3
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r)),
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
                                : AppColors.black,
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

    List<WeteamProjectUser> userList = controller.userList;
    List<_UserContainer> newUserContainerList = [];
    WeteamProjectUser? host;
    for (WeteamProjectUser projectUser in userList) {
      if (projectUser.user.id == controller.tp.value.host.id) {
        host = projectUser;
        continue;
      }
      if (!projectUser.enable) {
        continue;
      }
      newUserContainerList.add(_UserContainer(projectUser));
    }

    newUserContainerList.sort((a, b) {
      String userA = a.projectUser.user.username ?? "";
      String userB = b.projectUser.user.username ?? "";
      return userA.compareTo(userB);
    });

    if (host != null) controller.userContainerList.add(_UserContainer(host));
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
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !controller.tp.value.done,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    NormalButton(
                      onTap: () async {
                        ApiService service = Get.find<ApiService>();
                        Future invUrlFuture =
                            service.getTeamProjectInviteDeepLink(
                                controller.tp.value.id);
                        String? userName =
                            Get.find<AuthService>().user.value?.username;
                        String teamProjectName = controller.tp.value.title;

                        String? invUrl = await invUrlFuture;
                        if (invUrl != null) {
                          // 딥링크 생성 성공
                          invUrl =
                              Get.find<ApiService>().convertDeepLink(invUrl);

                          String inviteText =
                              '$userName님이 $teamProjectName에 초대했어요!\n$invUrl';

                          debugPrint(inviteText);
                          Share.share(inviteText);
                        } else {
                          WeteamUtils.snackbar('', '링크를 생성하지 못했어요');
                        }
                      },
                      width: 330.w,
                      height: 40.h,
                      text: '팀원 초대하기',
                    ),
                  ],
                )),
            SizedBox(height: 24.h),
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
                        color: AppColors.black,
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
                            _TextButton(
                                text: '팀플 기간 연장 (팀플 복구)',
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          TeamProjectDialog(
                                              mode:
                                                  TeamProjectDialogMode.revive,
                                              teamData: controller.tp.value));
                                }),
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
                                            teamData: controller.tp.value,
                                            mode: TeamProjectDialogMode.edit);
                                      });
                                }),
                            _TextButton(
                                text: '강제 퇴장 시키기',
                                onTap: () {
                                  if (controller.tp.value.memberSize == 1) {
                                    WeteamUtils.snackbar("", '강제 퇴장할 팀원이 없습니다');
                                    return;
                                  }
                                  controller.isKickMode.value =
                                      !controller.isKickMode.value;
                                }),
                            _TextButton(
                                text: '호스트 권한 넘기기',
                                onTap: () {
                                  if (controller.tp.value.memberSize == 1) {
                                    WeteamUtils.snackbar(
                                        "", '호스트를 넘겨 받을 팀원이 없습니다');
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
                        color: AppColors.black,
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
        ));
  }
}

class _CancelOrActionBottomPanel
    extends GetView<TeamProjectDetailPageController> {
  final String message;
  final String actionButtonText;
  final Function() action;
  final Function() cancelAction;

  const _CancelOrActionBottomPanel(
      {required this.message,
      required this.actionButtonText,
      required this.cancelAction,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          message,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 10.sp,
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
                child: NormalButton(
              whiteButton: true,
              height: 38.h,
              text: '취소',
              onTap: cancelAction,
              textStyle: TextStyle(
                color: AppColors.black,
                fontSize: 12.sp,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w800,
              ),
            )),
            SizedBox(width: 10.w),
            Expanded(
                child: NormalButton(
              onTap: () async {
                try {
                  dynamic ret = action.call();
                  if (ret is Future) await ret;
                } catch (e, st) {
                  WeteamUtils.snackbar("", "오류가 발생했어요",
                      icon: SnackbarIcon.fail);
                  debugPrint("$e");
                  debugPrintStack(stackTrace: st);
                }
              },
              height: 38.h,
              text: actionButtonText,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w800,
              ),
            ))
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
            color: AppColors.black,
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
        NormalButton(
          onTap: setRole,
          text: '확인',
          fontSize: 12.sp,
          width: 185.w,
          height: 32.h,
        )
      ],
    );
  }

  Future<void> setRole() async {
    String newRole = tec.text.trim();
    if (newRole.isEmpty) {
      WeteamUtils.snackbar("", "역할을 입력해 주세요", icon: SnackbarIcon.fail);
      return;
    }
    bool result = await Get.find<ApiService>()
        .changeUserTeamProjectRole(controller.tp.value, newRole);
    if (result) {
      Get.back();
      controller.fetchUserList();
    } else {
      WeteamUtils.snackbar("", "역할을 저장하지 못했어요", icon: SnackbarIcon.fail);
    }
  }
}
