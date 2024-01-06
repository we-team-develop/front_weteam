import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/app.dart';
import 'package:front_weteam/controller/profile_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/view/widget/profile_image_widget.dart';
import 'package:get/get.dart';

class ProfileSettingPage extends StatelessWidget {
  ProfileSettingPage({Key? key}) : super(key: key);
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.0.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WE TEAM',
                  style: TextStyle(
                    fontFamily: 'SBaggroB',
                    color: const Color(0xFFE2583E),
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0.sp,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '팀원들에게 보여줄 프로필 사진을 선택해 주세요:)',
                  style: TextStyle(
                    fontFamily: 'NanumGothicBold',
                    fontSize: 14.0.sp,
                  ),
                ),
                SizedBox(height: 73.0.h),
                const ProfileImageWidget(),
                SizedBox(height: 143.0.h),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 67.h,
            ),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => const App());
                },
                child: Image.asset(
                  ImagePath.startweteambutton,
                  width: 330.w,
                  height: 38.h,
                )),
          ),
        ),
      ],
    );
  }
}