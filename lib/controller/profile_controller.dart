import 'package:flutter/material.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:get/get.dart';

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
