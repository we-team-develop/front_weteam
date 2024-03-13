import 'dart:async';
import 'dart:developer';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/color_data.dart';
import '../../data/image_data.dart';
import '../../main.dart';
import '../../service/auth_service.dart';
import '../../util/helper/auth_helper.dart';
import '../../util/helper/google_auth_helper.dart';
import '../../util/helper/kakao_auth_helper.dart';
import '../../util/helper/naver_auth_helper.dart';
import '../../util/weteam_utils.dart';
import '../widget/profile_image_widget.dart';
import 'sign_up_completed.dart';

class LoginMain extends StatelessWidget {
  final Rxn<OverlayEntry> _overlayEntry = Rxn<OverlayEntry>();
  LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.White,
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    var padding = 4.h; // 버튼 사이 패딩

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                ImagePath.bigWeteamTimiIcon,
                width: 108.w,
                height: 140.h,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => login(GoogleAuthHelper(), context),
                child: Image.asset(
                  ImagePath.googlelogin,
                  width: 302.w,
                  height: 39.h,
                ),
              ),
              SizedBox(height: padding),
              // 임시 회원
              GestureDetector(
                onTap: () {
                  Get.to(() => const SignUpCompleted());
                },
                child: Image.asset(
                  ImagePath.applelogin,
                  width: 302.w,
                  height: 39.h,
                ),
              ),
              SizedBox(height: padding),
              GestureDetector(
                child: Image.asset(
                  ImagePath.naverlogin,
                  width: 302.w,
                  height: 39.h,
                ),
                onTap: () => login(NaverAuthHelper(), context),
              ),
              SizedBox(height: padding),
              GestureDetector(
                onTap: () => login(KakaoAuthHelper(), context),
                child: Image.asset(
                  ImagePath.kakaologin,
                  width: 302.w,
                  height: 39.h,
                ),
              ),
              SizedBox(height: padding),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            ],
          ),
        ],
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    _overlayEntry.value = OverlayEntry(
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: Stack(fit: StackFit.expand, children: [
                // 배경
                const Opacity(
                  opacity: 0.5,
                  child: ModalBarrier(dismissible: true, color: Colors.black),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _AnimatedTimi(),
                      SizedBox(height: 15.h),
                      Text('로그인 중 입니다',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.bold,
                              color: AppColors.White
                          ))
                    ],
                  ),
                )
              ])),
        ));
    Overlay.of(context).insert(_overlayEntry.value!);
  }

  void login(AuthHelper helper, BuildContext context) async {
    showFlexibleBottomSheet(
      decoration: BoxDecoration(
          color: Colors.transparent
      ),
      bottomSheetColor: Colors.transparent,
      barrierColor: Colors.transparent,
      draggableScrollableController: DraggableScrollableController(),
      isSafeArea: true,
      context: context,
      builder: (context, scrollController, bottomSheetOffset) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              decoration: BoxDecoration(
                  color: AppColors.White,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  boxShadow:[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 20,
                      blurRadius: 20,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          color: AppColors.G_03
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox.shrink(),
                      Text(
                        '2024. 01. 20 17:00',
                        style: TextStyle(
                            fontFamily: "NanumSquareNeo",
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp
                        ),
                      ),
                      Text("X")
                    ],
                  ),
                  Text('',
                  maxLines: 4,
                  overflow: TextOverflow(
                    
                  ),)
                  SizedBox(height: 16.h),
                  Container(height: 0.5.h,
                      color: AppColors.G_02),
                  SizedBox(height: 8.h),
                  Text('참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n참여 가능 : 40명\n',
                    style: TextStyle(
                        fontFamily: "NanumSquareNeo",
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      anchors: [0, 0.5, 1],
    );

    return;
    try {
      _showOverlay(context);
      // TODO: 로그인 버튼 중복 클릭 방지
      LoginResult result = await Get.find<AuthService>().login(helper);
      if (result.isSuccess) {
        sharedPreferences.setBool(
            SharedPreferencesKeys.isRegistered, !result.isNewUser);
        if (result.isNewUser) {
          Get.offAll(() => const SignUpCompleted());
        } else {
          resetApp();
        }
      } else {
        WeteamUtils.snackbar("", "로그인에 실패하였습니다", icon: SnackbarIcon.fail);
      }
    } catch (e) {
      log("$e");
      WeteamUtils.snackbar("", "로그인 중 오류가 발생했어요", icon: SnackbarIcon.fail);
    }
    _overlayEntry.value?.remove();
    _overlayEntry.value = null;
  }
}

class _AnimatedTimi extends StatefulWidget {
  @override
  State<_AnimatedTimi> createState() => _AnimatedTimiState();
}

class _AnimatedTimiState extends State<_AnimatedTimi> {
  late Timer timer;
  int index = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        if (mounted) {
          index = (index + 1) % 6;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileImageWidget(id: index);
  }
}