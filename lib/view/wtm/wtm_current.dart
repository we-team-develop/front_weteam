import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/profile_image_widget.dart';
import 'package:get/get.dart';

import '../../controller/wtm/wtm_current_controller.dart';
import '../../data/color_data.dart';
import '../../data/image_data.dart';
import '../widget/normal_button.dart';
import '../widget/wtm_project_widget.dart';
import '../widget/wtm_schedule_widget.dart';
import 'wtm_select_time.dart';

class WTMCurrent extends GetView<WTMCurrentController> {
  WTMCurrent({super.key});

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 21.0.h),
          child: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head(),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            height: 1.h,
            color: AppColors.G_01,
          ),
          SizedBox(
            height: 14.h,
          ),
          SizedBox(
            height: 57.h,
            child: Obx(
              () => PageView(
                controller: pageController,
                children: [
                  _teamInfo(), // 첫 번째 페이지: 해당 팀플 정보
                  _participantsPage(), // 두 번째 페이지: 참여자 확인 페이지
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Divider(height: 1.h, color: AppColors.G_01),
          Padding(
            padding: EdgeInsets.only(left: 4.w, top: 6.h),
            child: Image.asset(
              ImagePath.inforicon,
              width: 19.w,
              height: 19.h,
            ),
          ),
          Expanded(child: WTMSchedule(controller.wtm.value, false)),
          SizedBox(height: 11.05.h),
          NormalButton(
              text: '가능 시간 입력',
              onTap: () async {
                Get.to(() => const WTMSelectTime());
              }),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _head() {
    return Center(
      child: Text(
        '언제보까 현황',
        style: TextStyle(
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _teamInfo() {
    return Stack(
      children: [
        WTMProjectWidget(
          controller.wtm.value,
          showlink: false,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Text(
            '참여자 확인>',
            style: TextStyle(
                fontFamily: 'NanumSquareNeo',
                fontWeight: FontWeight.bold,
                fontSize: 9.sp),
          ),
        ),
      ],
    );
  }

  Widget _participantsPage() {
    return Row(
      children: [
        Expanded(
          child: _participant(),
        ),
        VerticalDivider(
          width: 1.w,
          color: AppColors.G_02,
        ),
        Expanded(
          child: _nonParticipant(),
        ),
      ],
    );
  }

  Widget _participant() {
    return Padding(
      padding: EdgeInsets.only(left: 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '참여 완료',
            style: TextStyle(
              fontFamily: 'NanumSquareNeoBold',
              fontSize: 12.sp,
            ),
          ),
          // 참여한 사용자 불러오기
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount:
                    controller.joinedUserList.length, // 참여한 유저 수만큼 아이템을 생성합니다.
                itemBuilder: (context, index) {
                  var user = controller.joinedUserList[index]; // 참여한 유저를 가져옵니다.
                  return Align(
                      alignment: Alignment.centerLeft,
                      child: _joinedUser(user));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _joinedUser(user) {
    return Column(
      children: [
        SizedBox(
          width: 26.w,
          height: 26.h,
          child: ProfileImageWidget(id: user.profile?.imageIdx ?? 0),
        ),
        Text(
          user.username,
          style: TextStyle(fontFamily: 'NanumSquareNeoBold', fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget _nonParticipant() {
    return Padding(
      padding: EdgeInsets.only(left: 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '미참여',
            style: TextStyle(fontFamily: 'NanumSquareNeoBold', fontSize: 12.sp),
          ),
          // 미참여 불러오기
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller
                    .notJoinedUserList.length, // 참여한 유저 수만큼 아이템을 생성합니다.
                itemBuilder: (context, index) {
                  var user =
                      controller.notJoinedUserList[index]; // 참여한 유저를 가져옵니다.
                  return Align(
                      alignment: Alignment.centerLeft,
                      child: _joinedUser(user));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
