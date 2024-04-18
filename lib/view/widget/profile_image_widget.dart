import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/profile_controller.dart';
import '../../data/color_data.dart';

double circleSize = 85.0.w;
double checkMarkSize = circleSize / 2;

class ProfileImageSelectContainerWidget extends GetView<ProfileController> {
  const ProfileImageSelectContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 0.0.h,
            crossAxisSpacing: 0.0.w,
            childAspectRatio: 1), // 정사각형 비율
        itemCount: controller.imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => controller.selectProfile(index),
            child: Obx(() => Stack(
                  alignment: Alignment.center,
                  children: [
                    ProfileImageWidget(id: index),
                    if (controller.isSelectedList[index])
                      // Image.asset(
                      //   ImagePath.check,
                      //   width: checkMarkSize,
                      //   height: checkMarkSize,
                      // )
                      Container(
                        width: 86.w,
                        height: 86.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                            width: 7.w,
                            color: AppColors.Orange_03,
                          ),
                        ),
                      ),
                  ],
                )),
          );
        },
      ),
    );
  }
}

class ProfileImageWidget extends StatefulWidget {
  final int id;
  const ProfileImageWidget({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _ProfileImageWidgetState();
  }
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        Color backgroundColor = controller.backgroundColors[widget.id];
        return Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            image: DecorationImage(
              image: AssetImage(controller.imagePaths[widget.id]),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
