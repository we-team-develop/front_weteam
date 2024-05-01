import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/meeting/meeting_create_controller.dart';
import '../../../data/app_colors.dart';
import '../../../data/image_data.dart';
import '../../../service/api_service.dart';
import '../../../util/weteam_utils.dart';
import '../../widget/normal_button.dart';

class MeetingCreateFinish extends GetView<MeetingCreateController> {
  const MeetingCreateFinish({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            const _Title(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child:
              Image.asset(ImagePath.thumbTimi, width: 153.w, height: 54.6.h),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                      fontFamily: 'NanumGothic',
                      fontSize: 12.sp,
                      color: AppColors.black),
                  children: [
                    _boldTS(_formatDateTime(controller.startedAt!)),
                    const TextSpan(text: ' 부터 '),
                    _boldTS(_formatDateTime(controller.endedAt!)),
                    const TextSpan(text: '까지\n'),
                    _boldTS(
                        '총 ${controller.endedAt!.difference(controller.startedAt!).inDays}일,\n\n'),
                    if (controller.selectedTeamProject.value != null) TextSpan(
                        children: [
                          _boldTS('[${controller.selectedTeamProject.value?.title}]'),
                          const TextSpan(text: '의\n'),
                        ]
                    ),
                    _boldTS('[${controller.nameInputText.value}]'),
                    const TextSpan(text: ' 약속을 잡는\n언제보까가 생성되었습니다~!'),
                  ]),
            ),
            _CopyLinkButton(),
            const Expanded(child: SizedBox()),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: NormalButton(
                    text: '확인',
                    onTap: () async {
                      await WeteamUtils.closeSnackbarNow();
                      Get.back();
                      Get.back();
                      Get.back();
                      Get.back();
                    })),
            GestureDetector(
              onTap: () async {
                await WeteamUtils.closeSnackbarNow();
                Get.back();
                Get.back();
              },
              child: RichText(
                  text: TextSpan(
                    children: const [
                      TextSpan(text: '수정할게 있어요. '),
                      TextSpan(
                          text: '수정하기',
                          style: TextStyle(decoration: TextDecoration.underline))
                    ],
                    style: TextStyle(
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.bold,
                        color: AppColors.g5,
                        fontSize: 10.sp),
                  )),
            ),
            SizedBox(height: 15.h)
          ],
        ),
      ),
    );
  }

  TextSpan _boldTS(String text) {
    return TextSpan(
        text: text, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.year}년 ${_padLeft(dt.month)}월 ${_padLeft(dt.day)}일";
  }

  String _padLeft(int num) {
    return num.toString().padLeft(2, '0');
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text('우리 언제보까!',
        style: TextStyle(
            fontFamily: 'NanumSquareNeo',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold));
  }
}

class _CopyLinkButton extends GetView<MeetingCreateController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(
            text: Get.find<ApiService>()
                .convertDeepLink('weteam://meeting/add?id=0')));
        WeteamUtils.snackbar('', '언제보까 링크를 복사했어요.', icon: SnackbarIcon.success);
      },
      child: Container(
        height: 40.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.g1, width: 1),
            color: AppColors.orange1),
        child: Center(
          child: Text("공유 링크 복사",
              style:
              TextStyle(fontFamily: 'NanumGothicExtraBold', fontSize: 15.sp)),
        ),
      ),
    );
  }
}
