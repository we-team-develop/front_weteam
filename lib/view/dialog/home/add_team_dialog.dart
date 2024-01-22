import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/home_controller.dart';
import 'package:front_weteam/controller/tp_controller.dart';
import 'package:front_weteam/service/api_service.dart';
import 'package:front_weteam/view/dialog/custom_big_dialog.dart';
import 'package:front_weteam/view/widget/custom_text_field.dart';
import 'package:front_weteam/view/widget/normal_button.dart';
import 'package:get/get.dart';

import '../../widget/custom_date_picker.dart';

class AddTeamDialog extends StatefulWidget {
  const AddTeamDialog({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddTeamDialog();
  }
}

class _AddTeamDialog extends State<AddTeamDialog> {
  final int maxContentLength = 25;

  final maxTitleLength = 20;
  String titleValue = "";

  String inputValue = "";
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool warningVisible = false;
  String warningContent = "";

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return CustomBigDialog(title: '팀플 추가', child: _body());
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.min, // 이거 없으면 dialog가 엄청 길어요
      crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
      children: <Widget>[
        CustomTextField(hint: "팀플명", maxLength: 20, controller: titleController),
        SizedBox(
          height: 12.h,
        ),
        Row(
          // 상세내용이 왼쪽 정렬
          children: [
            Text(
              '상세내용',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 12,
                fontFamily: 'NanumSquareNeo',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Stack(
          children: [
            ConstrainedBox(
                constraints: BoxConstraints(minHeight: 60.h, minWidth: 260.w),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        side:
                        const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: TextField(
                    controller: contentController,
                    maxLines: 5,
                    maxLength: maxContentLength,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      // 여백 제거
                      contentPadding: EdgeInsets.all(0),
                      isDense: true,
                    ),
                    cursorColor: const Color(0xFFE2583E), // 깜빡이는 커서의 색 변경
                    style: const TextStyle(fontSize: 13),
                    onChanged: (newV) {
                      setState(() {
                        inputValue = newV;
                      });
                    },
                  ),
                )),
            Positioned(
              right: 10,
                bottom: 10,
                child: Text(
              // TextField 오른쪽에 counter
              "${inputValue.length} / ${maxContentLength}",
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 10,
                fontFamily: 'NanumSquareNeo',
                fontWeight: FontWeight.w400,
                height: 0.26,
              ),
            ))
          ],
        ),
        SizedBox(
          height: 24.h,
        ),
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
                            fontSize: 12,
                            fontFamily: 'NanumSquareNeo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        CustomDatePicker(
                            start: DateTime(1980, 1, 1),
                            end: DateTime(2090, 12, 31),
                            init: startTime,
                            onChangeListener: (v) {
                              startTime = v;
                            }),
                      ],
                    )),
                Container(
                  width: 1,
                  height: 90.h,
                  margin: EdgeInsets.symmetric(horizontal: 21.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCDCDC),
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
                            fontSize: 12,
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
          height: 34.h,
        ),
        Visibility(
          visible: warningVisible,
            child: Text(warningContent,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFE2583E),
              fontFamily: 'NanumSquareNeo',
              fontSize: 10.sp))),
        NormalButton(text: '확인', onTap: () async {
          if (isSaving) return;
          isSaving = true;
          try {
            addTeamProject();
          } catch (e, st) {
            debugPrint('$e');
            debugPrintStack(stackTrace: st);
          }
          isSaving = false;
        }),
      ],
    );
  }

  Future<void> addTeamProject() async {
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

    bool success = await Get.find<ApiService>().createTeamProject(name, startTime, endTime, content);
    if (success) {
      await Get.find<HomeController>().updateTeamProjectList();
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
