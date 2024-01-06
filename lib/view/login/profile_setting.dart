import 'package:flutter/material.dart';
import 'package:front_weteam/app.dart';
import 'package:front_weteam/controller/profile_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:get/get.dart';

class ProfileSettingPage extends StatelessWidget {
  ProfileSettingPage({Key? key}) : super(key: key);
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WE TEAM',
                  style: TextStyle(
                    fontFamily: 'SBaggroB',
                    color: Color(0xFFE2583E),
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '팀원들에게 보여줄 프로필 사진을 선택해 주세요!',
                  style: TextStyle(
                    fontFamily: 'NanumGothicBold',
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 50.0),
                _profileImage(),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.08,
                left: 15.0,
                right: 15.0),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => const App());
                },
                child: Image.asset(ImagePath.startweteambutton)),
          ),
        ),
      ],
    );
  }

  Widget _profileImage() {
    double circleSize = 100.0;
    double checkMarkSize = circleSize / 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1 // 정사각형 비율
          ),
      itemCount: controller.imagePaths.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => controller.selectProfile(index),
          child: Obx(() => Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: AssetImage(controller.imagePaths[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (controller.isSelected[index])
                    Positioned(
                      top: (circleSize - checkMarkSize) / 2,
                      bottom: (circleSize - checkMarkSize) / 2,
                      left: (circleSize - checkMarkSize) / 2,
                      right: (circleSize - checkMarkSize) / 2,
                      child: Image.asset(
                        ImagePath.check,
                        width: checkMarkSize,
                        height: checkMarkSize,
                      ),
                    ),
                ],
              )),
        );
      },
    );
  }
}
