import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/meeting/meeting_current_controller.dart';
import '../../data/color_data.dart';
import '../widget/normal_button.dart';
import '../widget/profile_image_widget.dart';
import '../widget/meeting_widget.dart';
import '../widget/meeting_schedule_widget.dart';
import 'meeting_select_time.dart';

class MeetingCurrent extends GetView<CurrentMeetingController> {
  final PageController pageController = PageController();

  MeetingCurrent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 21.0.h),
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
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
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15.h),
                  Text(
                    '타임블록에서 참여 가능한 인원을 확인할 수 있어요.',
                    style: TextStyle(
                      fontFamily: 'NanumSquareNeoBold',
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center, // 가운데 정렬
                  ),
                  SizedBox(height: 15.h),
                  // 이미지 경로를 동적으로 변경
                  Image.asset(
                    controller.getImagePathForUserCount(), // 동적 이미지 경로
                    height: controller.getImageHeightForUserCount(),
                  ),
                  SizedBox(height: 22.h),
                ],
              ),
            ),
          ),
          Expanded(child: MeetingSchedule(controller.meeting.value, false)),
          SizedBox(height: 11.05.h),
          NormalButton(
              text: '가능 시간 입력',
              onTap: () async {
                Get.to(() => const MeetingSelectTime());
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
        MeetingWidget(
          controller.meeting.value,
          showlink: false,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            // 텍스트 위젯을 GestureDetector로 랩하여 탭 처리
            onTap: () {
              pageController.animateToPage(
                1, //
                duration: const Duration(milliseconds: 300), //
                curve: Curves.easeInOut, // Animation curve
              );
            },
            child: Text(
              '참여자 확인>',
              style: TextStyle(
                  fontFamily: 'NanumSquareNeo',
                  fontWeight: FontWeight.bold,
                  fontSize: 9.sp),
            ),
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
      padding: EdgeInsets.only(left: 14.w, right: 14.w), // 패딩이 양쪽에서 대칭인지 확인
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '미참여',
                style: TextStyle(
                    fontFamily: 'NanumSquareNeoBold', fontSize: 12.sp),
              ),
              const Spacer(), // 텍스트 및 제스처 디텍터 분리
              GestureDetector(
                onTap: () {
                  pageController.animateToPage(
                    0, // Index of the _teamInfo page in the PageView
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  '돌아가기>',
                  style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.bold,
                    fontSize: 9.sp,
                  ),
                ),
              ),
            ],
          ),
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
