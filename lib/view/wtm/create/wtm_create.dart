import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/wtm_controller.dart';
import '../../../data/color_data.dart';
import '../../../data/image_data.dart';
import '../../../model/team_project.dart';
import '../../widget/team_project_widget.dart';
import 'wtm_naming.dart';

class WTMCreate extends GetView<WTMController> {
  const WTMCreate({super.key});

  @override
  StatelessElement createElement() {
    controller.setSelectedTpList('진행중인 팀플');
    return super.createElement();
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
            return const Center(
                child: Text('표시할 팀플이 없어요',
                    style: TextStyle(color: AppColors.Black)));
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
            _checkBox(),
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
              color: isSelected ? AppColors.MainOrange : Colors.transparent,
              width: 2.w,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.MainOrange : AppColors.G_02),
        ),
      ),
    );
  }

  Widget _checkBox() {
    return GestureDetector(
        onTap: () {
          if (controller.selectedTeamProject.value != null) {
            Get.to(() => const WTMNaming(), transition: Transition.rightToLeft);
          }
        },
        child: Obx(() => Container(
              width: 330.w,
              height: 46.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: controller.selectedTeamProject.value != null
                    ? AppColors.MainOrange
                    : AppColors.G_02,
              ),
              child: Center(
                child: Text(
                  '선택 완료',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: 'NanumGothicExtraBold',
                    color: Colors.white,
                  ),
                ),
              ),
            )));
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
                color: AppColors.G_05,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => const WTMNaming());
            },
            child: Text(
              '다음으로',
              style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  color: AppColors.G_05,
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
          color: isSelected ? AppColors.Orange_03 : AppColors.G_02,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Text(
        '선택',
        style: TextStyle(
            color: isSelected ? AppColors.White : AppColors.G_05,
            fontFamily: 'NanumSquareNeo',
            fontSize: 9.sp,
            fontWeight: FontWeight.bold),
      )),
    );
  }
}

class _Search extends GetView<WTMController> {
  const _Search();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.G_02, width: 1.w),
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