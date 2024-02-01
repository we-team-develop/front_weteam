import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/color_data.dart';
import '../data/image_data.dart';
import '../service/api_service.dart';
import '../service/auth_service.dart';

class ProfileController extends GetxController {
  RxList<String> imagePaths = RxList<String>([
    ImagePath.profile1,
    ImagePath.profile2,
    ImagePath.profile3,
    ImagePath.profile4,
    ImagePath.profile5,
    ImagePath.profile6,
  ]);

  var isSelected = List.generate(6, (index) => false).obs;

  RxList<Color> backgroundColors = RxList<Color>([
    AppColors.Purple,
    AppColors.Blue_02,
    AppColors.Pink_01,
    AppColors.Blue_01,
    AppColors.Yellow_01,
    AppColors.Pink_02,
  ]);

  RxBool isPushNotificationEnabled = false.obs;

  void selectProfile(int index) {
    Future.microtask(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
      isSelected.refresh();
    });
  }

  int? getSelectedProfileId() {
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) return i;
    }

    return null;
  }

  void togglePushNotification(bool value) {
    isPushNotificationEnabled.value = value;
  }

  String _getUserOrganization() {
    String? organization = Get.find<AuthService>().user.value?.organization;
    if (organization == null || organization.trim().isEmpty) {
      return "";
    }
    return organization;
  }

  void updateOrganization() {
    textController.text = _getUserOrganization();
  }

  // 소속
  Future<void> saveProfiles() async {
    String organization = textController.text;
    if (_getUserOrganization() != organization) {
      if (!await Get.find<ApiService>().setUserOrganization(organization)) {
        // 한번 더 재시도
        if (!await Get.find<ApiService>().setUserOrganization(organization)) {
          Get.snackbar("죄송합니다", "소속을 변경하지 못했습니다");
        }
      }
      Get.find<AuthService>().user.value!.organization = organization;
    }

    int? profileId = getSelectedProfileId();
    if (profileId != null &&
        Get.find<AuthService>().user.value!.profile?.imageIdx != profileId) {
      await Get.find<ApiService>().changeUserProfiles(profileId);
    }

    Get.find<AuthService>().user.value =
        await Get.find<ApiService>().getCurrentUser();
  }

  final TextEditingController textController = TextEditingController();
  final RxInt textLength = 0.obs;

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      textLength.value = textController.text.length;
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
