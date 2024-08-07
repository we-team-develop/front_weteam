import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/app_colors.dart';
import '../../../model/team_project.dart';
import '../../../service/api_service.dart';
import '../../../service/team_project_service.dart';
import '../../../util/weteam_utils.dart';
import '../../widget/custom_date_picker.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/normal_button.dart';
import '../custom_big_dialog.dart';

class TeamProjectDialog extends StatefulWidget {
  final TeamProject? teamData;
  final TeamProjectDialogMode mode;

  const TeamProjectDialog({super.key, this.teamData, required this.mode});

  @override
  State<StatefulWidget> createState() {
    return _TeamProjectDialogState();
  }
}

class _TeamProjectDialogState extends State<TeamProjectDialog> {
  final int maxContentLength = 25;

  final maxTitleLength = 20;

  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  String title = "";

  @override
  void initState() {
    if (widget.mode != TeamProjectDialogMode.add) {
      titleController.text = widget.teamData!.title;
      contentController.text = widget.teamData!.description;
      startTime = widget.teamData!.startedAt;
      endTime = widget.teamData!.endedAt;

      if (widget.mode == TeamProjectDialogMode.edit) {
        title = '팀플 정보 수정';
      } else {
        title = '팀플 기간 연장';
      }
    } else {
      title = '팀플 추가';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBigDialog(title: title, child: _body());
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.min, // 이거 없으면 dialog가 엄청 길어요
      crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
      children: [
        // 남은 부분을 채우지만, 자식 크기보다 커질 수는 없습니다.
        Flexible(
            // 키보드 입력시 일부 내용 가려지도록 scroll view 사용
            child: SingleChildScrollView(
          // 스크롤을 아예 막아두어 의도하지 않은 동작을 방지합니다.
          physics: const NeverScrollableScrollPhysics(),
          // 팀플명, 상세내용, 시작일, 종요일에 대한 위젯들
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // 세로 크기를 최소한으로 설정
            crossAxisAlignment: CrossAxisAlignment.center,
            // 자식 위젯 (가로)중앙 정렬
            children: <Widget>[
              Visibility(
                  visible: widget.mode != TeamProjectDialogMode.revive,
                  child: CustomTextField(
                      hint: "팀플명", maxLength: 20, controller: titleController)),
              Visibility(
                  visible: widget.mode == TeamProjectDialogMode.revive,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('프로젝트명',
                              style: TextStyle(
                                  fontFamily: 'NanumSquareNeo',
                                  fontSize: 12.sp,
                                  color: AppColors.g5)),
                          Text(' ${widget.teamData?.title}',
                              style: TextStyle(
                                  fontFamily: 'NanumSquareNeo',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black)),
                        ],
                      )
                    ],
                  )),
              SizedBox(
                height: 26.h,
              ),
              Visibility(
                  visible: widget.mode != TeamProjectDialogMode.revive,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상세내용',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 12.sp,
                          fontFamily: 'NanumSquareNeo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Stack(
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: 60.h, minWidth: 260.w),
                              child: Container(
                                padding: const EdgeInsets.all(10).r,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.r, color: AppColors.g2),
                                      borderRadius: BorderRadius.circular(8.r)),
                                ),
                                child: TextField(
                                  controller: contentController,
                                  onTapOutside: (v) {
                                    // 다른 곳 터치시 키보드 숨김
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  maxLines: 5,
                                  maxLength: maxContentLength,
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    // 여백 제거
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                  cursorColor: AppColors.mainOrange,
                                  // 깜빡이는 커서의 색 변경
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppColors.g5,
                                      fontFamily: 'NanumSqaureNeo',
                                      fontWeight: FontWeight.bold),
                                  onChanged: (newV) {
                                    setState(() {});
                                  },
                                ),
                              )),
                          Positioned(
                              right: 10.w,
                              bottom: 10.h,
                              child: Text(
                                // TextField 오른쪽에 counter
                                "${contentController.text.length} / $maxContentLength",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 10.sp,
                                  fontFamily: 'NanumSquareNeo',
                                  fontWeight: FontWeight.w400,
                                  height: 0.26,
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 24.h,
                      )
                    ],
                  )),
              ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 304.w),
                  child: Row(
                    children: [
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '시작일',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 12.sp,
                              fontFamily: 'NanumSquareNeo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Visibility(
                              visible:
                                  widget.mode != TeamProjectDialogMode.revive,
                              child: CustomDatePicker(
                                  start: DateTime(1980, 1, 1),
                                  end: DateTime(2090, 12, 31),
                                  init: startTime,
                                  onChangeListener: (v) {
                                    startTime = v;
                                  })),
                          Visibility(
                              visible:
                                  widget.mode == TeamProjectDialogMode.revive,
                              child: Text(
                                "${startTime.year}. ${startTime.month.toString().padLeft(2, '0')}. ${startTime.day.toString().padLeft(2, '0')}",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontFamily: 'NanumSquareNeo',
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      )),
                      Container(
                        width: 1,
                        height: 90.h,
                        margin: EdgeInsets.symmetric(horizontal: 21.w),
                        decoration: const BoxDecoration(
                          color: AppColors.g2,
                        ),
                      ),
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '종료일',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 12.sp,
                              fontFamily: 'NanumSquareNeo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          CustomDatePicker(
                              start: DateTime(1980, 1, 1),
                              end: DateTime(2090, 12, 31),
                              init: endTime,
                              onChangeListener: (v) {
                                endTime = v;
                              }),
                        ],
                      ))
                    ],
                  )),
              SizedBox(
                height: 27.h,
              ),
              Visibility(
                  visible: widget.mode == TeamProjectDialogMode.revive,
                  child: Column(
                    children: [
                      Text(
                        '※ 종료일은 금일 이후 날짜부터 변경 가능합니다.',
                        style: TextStyle(
                            color: AppColors.g5,
                            fontFamily: 'NanumSquareNeo',
                            fontSize: 10.sp),
                      ),
                      SizedBox(height: 23.h)
                    ],
                  )),
            ],
          ),
        )),

        // 확인 버튼 영역입니다.
        // 키보드가 올라와도 확인 버튼은 올라올 수 있도록 하였습니다.
        Padding(
          // 확인 버튼 윗 부분에 약간의 여백을 추가합니다.
          padding: EdgeInsets.only(top: 2.h),
          child: NormalButton(
              text: '확인',
              width: 185.w,
              height: 40.h,
              fontSize: 12.sp,
              onTap: () async {
                try {
                  await updateTeamProject();
                } catch (e, st) {
                  debugPrint('$e');
                  debugPrintStack(stackTrace: st);
                  WeteamUtils.snackbar('', '오류가 발생하여 불러오지 못했어요');
                }
              }),
        )
      ],
    );
  }

  Future<void> updateTeamProject() async {
    String name = titleController.text.trim();
    String content = contentController.text.trim();

    if (name.isEmpty) {
      setState(() {
        WeteamUtils.snackbar('', '팀플명을 입력해 주세요', icon: SnackbarIcon.info);
      });
      return;
    }

    if (content.isEmpty) {
      setState(() {
        WeteamUtils.snackbar('', '상세내용을 입력해 주세요', icon: SnackbarIcon.info);
      });
      return;
    }

    if (endTime.isBefore(startTime)) {
      setState(() {
        WeteamUtils.snackbar('', '시작일이 종료일보다 빠를 수 없어요',
            icon: SnackbarIcon.info);
      });
      return;
    }

    if (endTime.isBefore(WeteamUtils.onlyDate(DateTime.now()))) {
      setState(() {
        WeteamUtils.snackbar('', '종료일은 오늘 이전일 수 없어요', icon: SnackbarIcon.info);
      });
      return;
    }

    if (widget.mode == TeamProjectDialogMode.revive) {
      if (endTime.difference(DateTime.now()).inSeconds.isNegative) {
        setState(() {
          WeteamUtils.snackbar('', '종료일이 잘못 되었어요', icon: SnackbarIcon.info);
        });
        return;
      }
    }

    late bool success;
    if (widget.teamData == null) {
      success = await Get.find<ApiService>()
          .createTeamProject(name, startTime, endTime, content);
    } else {
      TeamProject newTp = TeamProject(
          id: widget.teamData!.id,
          host: widget.teamData!.host,
          endedAt: endTime,
          startedAt: startTime,
          memberSize: widget.teamData!.memberSize,
          description: contentController.text,
          title: titleController.text,
          done: endTime
              .difference(DateTime.now().copyWith(
                  hour: 0,
                  minute: 0,
                  second: 0,
                  millisecond: 0,
                  microsecond: 0))
              .inDays
              .isNegative,
          imageId: widget.teamData!.imageId);
      /*widget.teamData!.title = titleController.text.trim();
      widget.teamData!.description = contentController.text.trim();
      widget.teamData!.startedAt = startTime;
      widget.teamData!.endedAt = endTime;*/
      success = await Get.find<ApiService>().editTeamProject(newTp);
      Get.find<TeamProjectService>().updateEntry(newTp);
    }
    if (success) {
      await Get.find<TeamProjectService>().updateLists();
      WeteamUtils.closeDialog();
    } else {
      setState(() {
        WeteamUtils.snackbar('', '저장하지 못했어요', icon: SnackbarIcon.fail);
      });
      return;
    }
  }
}

enum TeamProjectDialogMode { add, edit, revive }
