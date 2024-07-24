import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/image_data.dart';

class MeetingInfoOverlay extends StatelessWidget {
  final VoidCallback onConfirm;

  const MeetingInfoOverlay({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onConfirm, // 오버레이 배경을 탭하면 콜백 실행
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.white,
              ),
              width: 293.w,
              height: 115.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "타임블록에서 최대 가능한 인원을 확인할 수 있어요.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontFamily: 'NanumGothic'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  // 예시 이미지
                  Image.asset(
                    ImagePath.infoImage,
                    width: 167.44.w,
                    height: 15.82.h,
                  ),
                  SizedBox(
                    height: 17.18.h,
                  ),
                  // 확인 버튼
                  GestureDetector(
                    onTap: onConfirm, //확인 버튼 안 눌림 수정
                    child: Text(
                      '확인',
                      style: TextStyle(
                        fontFamily: 'NanumGothicBold',
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
