import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/mainpage/tp_controller.dart';
import '../../../controller/team_project_detail_page_controller.dart';
import '../../../data/color_data.dart';
import '../../../main.dart';
import '../../../model/team_project.dart';
import '../../../service/api_service.dart';
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

  bool warningVisible = false;
  String warningContent = "";

  bool isSaving = false;

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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // 이거 없으면 dialog가 엄청 길어요
        crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
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
                              color: AppColors.G_05)),
                      Text(' ${widget.teamData?.title}',
                          style: TextStyle(
                              fontFamily: 'NanumSquareNeo',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.Black)),
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
                          constraints:
                              BoxConstraints(minHeight: 60.h, minWidth: 260.w),
                          child: Container(
                            padding: const EdgeInsets.all(10).r,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1.r, color: AppColors.G_02),
                                  borderRadius: BorderRadius.circular(8.r)),
                            ),
                            child: TextField(
                              controller: contentController,
                              maxLines: 5,
                              maxLength: maxContentLength,
                              decoration: const InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                // 여백 제거
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              cursorColor:
                                  AppColors.MainOrange, // 깜빡이는 커서의 색 변경
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.G_05,
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
                          visible: widget.mode != TeamProjectDialogMode.revive,
                          child: CustomDatePicker(
                              start: DateTime(1980, 1, 1),
                              end: DateTime(2090, 12, 31),
                              init: startTime,
                              onChangeListener: (v) {
                                startTime = v;
                              })),
                      Visibility(
                          visible: widget.mode == TeamProjectDialogMode.revive,
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
                      color: AppColors.G_02,
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
                        color: AppColors.G_05,
                        fontFamily: 'NanumSquareNeo',
                        fontSize: 10.sp),
                  ),
                  SizedBox(height: 23.h)
                ],
              )),
          Visibility(
              visible: warningVisible,
              child: Text(warningContent,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.MainOrange,
                      fontFamily: 'NanumSquareNeo',
                      fontSize: 10.sp))),
          NormalButton(
              text: '확인',
              width: 185.w,
              height: 40.h,
              onTap: () async {
                if (isSaving) return;
                isSaving = true;
                try {
                  updateTeamProject();
                } catch (e, st) {
                  debugPrint('$e');
                  debugPrintStack(stackTrace: st);
                }
                isSaving = false;
              }),
        ],
      ),
    );
  }

  Future<void> updateTeamProject() async {
    String name = titleController.text.trim();
    String content = contentController.text.trim();

    if (name.isEmpty) {
      setState(() {
        warningVisible = true;
        warningContent = "팀플명을 입력해주세요!";
      });
      return;
    }

    if (content.isEmpty) {
      setState(() {
        warningVisible = true;
        warningContent = "상세내용을 입력해주세요!";
      });
      return;
    }

    if (endTime.difference(startTime).inDays.isNegative) {
      setState(() {
        warningVisible = true;
        warningContent = "시작일은 종료일보다 빠를 수 없어요!";
      });
      return;
    }

    if (widget.mode == TeamProjectDialogMode.revive) {
      if (endTime.difference(DateTime.now()).inSeconds.isNegative) {
        setState(() {
          warningVisible = true;
          warningContent = "종료일이 잘못 되었습니다.";
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
          img: widget.teamData!.img);
      /*widget.teamData!.title = titleController.text.trim();
      widget.teamData!.description = contentController.text.trim();
      widget.teamData!.startedAt = startTime;
      widget.teamData!.endedAt = endTime;*/
      success = await Get.find<ApiService>().editTeamProject(newTp);
      if (success) {
        Get.find<TeamProjectDetailPageController>().tp.value = newTp;
      }
    }
    if (success) {
      await updateTeamProjectLists();
      Get.back();
      Get.find<TeamPlayController>().updateTeamProjectList();
    } else {
      setState(() {
        warningVisible = true;
        warningContent = "저장하지 못했어요";
      });
      return;
    }
  }
}

enum TeamProjectDialogMode { add, edit, revive }
