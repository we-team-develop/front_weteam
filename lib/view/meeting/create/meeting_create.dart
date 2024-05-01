import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/meeting/meeting_create_controller.dart';
import '../../../data/app_colors.dart';
import '../../../data/image_data.dart';
import '../../../model/team_project.dart';
import '../../widget/normal_button.dart';
import '../../widget/team_project_widget.dart';
import 'meeting_naming.dart';

class MeetingCreate extends GetView<MeetingCreateController> {
  const MeetingCreate({super.key});

  @override
  StatelessElement createElement() {
    controller.setSelectedTpList('진행중인 팀플');
    return super.createElement();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40.h, left: 15.w),
          child: _head(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
          child: const _Search(),
        ),
        Obx(() => Row(
              children: [
                Expanded(
                    child: _tplist("진행중인 팀플",
                        controller.selectedTpList.value == "진행중인 팀플")),
                Expanded(
                    child: _tplist(
                        "완료된 팀플", controller.selectedTpList.value == "완료된 팀플")),
              ],
            )),
        Expanded(child: Obx(() {
          if (controller.tpList.isEmpty) {
            return Center(
                child: Text('표시할 팀플이 없어요',
                    style: TextStyle(color: AppColors.black, fontSize: 12.sp)));
          }

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 15.w),
            child: ListView.builder(
              itemCount: controller.tpList.length,
              itemBuilder: (_, index) => Obx(() {
                TeamProject tp = controller.tpList[index];
                String searchText = controller.searchText.value;

                // 검색어에 본인이 포함되지 않을 경우
                if (searchText.isNotEmpty && !tp.title.contains(searchText)) {
                  return const SizedBox.shrink();
                }

                return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      controller.selectedTeamProject.value = tp;
                    },
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(children: [
                          // IgnorePointer를 사용하여 터치시 팀플 화면이 나오는 걸 방지
                          Expanded(
                              child:
                                  IgnorePointer(child: TeamProjectWidget(tp))),
                          SizedBox(width: 16.w),
                          Obx(() {
                            bool isSelected =
                                controller.selectedTeamProject.value?.id ==
                                    tp.id;
                            return _SelectButton(isSelected);
                          })
                        ])));
              }),
            ),
          );
        })),
        Center(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: _checkBox(),
            ),
            SizedBox(height: 16.h),
            _nextText(),
            SizedBox(height: 15.h),
          ],
        )),
      ],
    );
  }

  Widget _head() {
    return Text(
      '어떤 팀플의 약속인가요?',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'NanumGothic',
          fontSize: 20.sp),
    );
  }

  Widget _tplist(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.setSelectedTpList(text),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.mainOrange : Colors.transparent,
              width: 2.r,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.mainOrange : AppColors.g2),
        ),
      ),
    );
  }

  Widget _checkBox() {
    return Obx(() => NormalButton(
          text: '선택 완료',
          onTap: () => Get.to(() => const MeetingNaming(),
              transition: Transition.rightToLeft),
          enable: controller.selectedTeamProject.value != null,
          width: 330.w,
          height: 40.h,
        ));
  }

  Widget _nextText() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '팀플을 미선택 할래요. ',
            style: TextStyle(
                fontFamily: 'NanumGothic',
                color: AppColors.g5,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => const MeetingNaming());
            },
            child: Text(
              '다음으로',
              style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  color: AppColors.g5,
                  decoration: TextDecoration.underline,
                  fontSize: 10.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectButton extends StatelessWidget {
  final bool isSelected;

  const _SelectButton(this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
          color: isSelected ? AppColors.orange3 : AppColors.g2,
          borderRadius: BorderRadius.circular(10.r)),
      child: Center(
          child: Text(
        '선택',
        style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.g5,
            fontFamily: 'NanumSquareNeo',
            fontSize: 9.sp,
            fontWeight: FontWeight.bold),
      )),
    );
  }
}

class _Search extends GetView<MeetingCreateController> {
  const _Search();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.g2, width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: TextField(
                    onChanged: (v) => controller.scheduleSearch(v),
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'NanumGothic',
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black),
                    decoration: const InputDecoration(
                        border: InputBorder.none, isDense: true),
                  ))),
          Image.asset(
            ImagePath.icSearch,
            width: 36.w,
            height: 36.h,
          ),
        ],
      ),
    );
  }
}
