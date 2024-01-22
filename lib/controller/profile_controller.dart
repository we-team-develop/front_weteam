import 'package:flutter/material.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/main.dart';
import 'package:front_weteam/service/api_service.dart';
import 'package:get/get.dart';

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
  RxBool isPushNotificationEnabled = false.obs;

  void selectProfile(int index) {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = i == index;
    }
    isSelected.refresh();
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
      if (!await Get.find<ApiService>().setUserOraganization(organization)) {
        // 한번 더 재시도
        if (!await Get.find<ApiService>().setUserOraganization(organization)) {
          Get.snackbar("죄송합니다", "소속을 변경하지 못했습니다");
        }
      }
      Get.find<AuthService>().user.value!.organization = organization;
    }

    int? profile = getSelectedProfileId();
    if (profile != null && Get.find<AuthService>().user.value!.profile != profile) {
      if(await Get.find<ApiService>().changeUserProfiles(profile)) {
        // 성공시
        print('$profile !');
        await sharedPreferences.setInt(SharedPreferencesKeys.userProfileIndex, profile);
      }
    }

    Get.find<AuthService>().user.value = await Get.find<ApiService>().getCurrentUser();
  }

  final TextEditingController textController = TextEditingController();
  final RxInt textLength = 0.obs;

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      textLength.value = textController.text.length;
    });
    selectProfile(Get.find<AuthService>().user.value!.profile);
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
