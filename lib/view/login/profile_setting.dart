import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/profile_controller.dart';
import '../../data/color_data.dart';
import '../../main.dart';
import '../../service/api_service.dart';
import '../../util/weteam_utils.dart';
import '../widget/normal_button.dart';
import '../widget/profile_image_widget.dart';

class ProfileSettingPage extends StatelessWidget {
  ProfileSettingPage({super.key});
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
                    color: AppColors.MainOrange,
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
                const ProfileImageSelectContainerWidget(),
                SizedBox(height: 143.0.h),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 32.h),
              child: Obx(() {
                controller.isSelected; // 리스너에 등록
                return NormalButton(
                  text: 'WE TEAM 시작하기',
                  enable: controller.getSelectedProfileId() != null,
                  onTap: setProfile,
                );
              })),
        )
      ],
    );
  }

  Future<void> setProfile() async {
    int id = controller.getSelectedProfileId() ?? 0;
    ApiService service = Get.find<ApiService>();

    try {
      bool fcmSuccess = await service.setFCMToken(); // FCM토큰을 서버에 전송합니다

      if (fcmSuccess && await service.createUserProfiles(id) &&
          (await service.getCurrentUser())?.profile != null) {
        await sharedPreferences.setBool(
            SharedPreferencesKeys.isRegistered, true);
        await resetApp();
      } else {
        WeteamUtils.snackbar("죄송합니다", "문제가 발생했습니다(1)", icon: SnackbarIcon.fail);
      }
    } catch (e, st) {
      debugPrint('$e');
      debugPrintStack(stackTrace: st);
      WeteamUtils.snackbar("죄송합니다", "문제가 발생했습니다(2)", icon: SnackbarIcon.fail);
    }
  }
}
