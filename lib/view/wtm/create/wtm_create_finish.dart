import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/wtm/wtm_controller.dart';
import '../../../data/color_data.dart';
import '../../../data/image_data.dart';
import '../../../util/weteam_utils.dart';

class WTMCreateFinish extends GetView<WTMController> {
  DateTime startAt = DateTime(2024, 2, 28); // TODO: controller에서 받아오기
  DateTime endAt = DateTime(2024, 3, 2);

  WTMCreateFinish({super.key}); // TODO: controller에서 받아오기

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
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
                    color: AppColors.Black),
                children: [
                  _boldTS(_formatDateTime(startAt)),
                  const TextSpan(text: ' 부터 '),
                  _boldTS(_formatDateTime(endAt)),
                  const TextSpan(text: '까지\n'),
                  _boldTS(
                      '총 ${endAt.difference(startAt).inDays}일,\n\n[${controller.selectedTeamProject.value?.title}]'),
                  const TextSpan(text: '의\n'),
                  _boldTS('[${controller.nameInputText.value}]'),
                  const TextSpan(text: ' 약속을 잡는\n언제보까가 생성되었습니다~!'),
                ]),
          ),
          _CopyLinkButton(),
          const Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () {
              Get.closeAllSnackbars();
              Get.back();
              Get.back();
              Get.back();
            },
            child: Container(
              height: 40.h,
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: AppColors.MainOrange,
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
              ),
              child: Center(
                  child: Text('확인',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'NanumGothicExtraBold',
                          fontSize: 15.sp))),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.closeAllSnackbars();
              Get.back();
              Get.back();
            },
            child: RichText(
                text: TextSpan(
              children: const [
                TextSpan(text: '수정할게 있어요.'),
                TextSpan(
                    text: ' 수정하기',
                    style: TextStyle(decoration: TextDecoration.underline))
              ],
              style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.bold,
                  color: AppColors.G_05,
                  fontSize: 10.sp),
            )),
          ),
          SizedBox(height: 15.h)
        ],
      ),
    ));
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

class _CopyLinkButton extends GetView<WTMController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(const ClipboardData(text: 'weteam://wtm/add?id=0'));
        WeteamUtils.snackbar('', '언제보까 링크를 복사했어요.', iconPath: ImagePath.greenCheck);
      },
      child: Container(
        height: 40.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.G_01, width: 1),
            color: AppColors.Orange_01),
        child: Center(
          child: Text("공유 링크 복사",
              style:
              TextStyle(fontFamily: 'NanumGothicExtraBold', fontSize: 15.sp)),
        ),
      ),
    );
  }
}
