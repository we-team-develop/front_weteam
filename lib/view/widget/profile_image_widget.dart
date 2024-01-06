import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/profile_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:get/get.dart';

class ProfileImageWidget extends GetView<ProfileController> {
  const ProfileImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double circleSize = 85.0.w;
    double checkMarkSize = circleSize / 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10.0.h,
          crossAxisSpacing: 10.0.w,
          childAspectRatio: 1), // 정사각형 비율
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
