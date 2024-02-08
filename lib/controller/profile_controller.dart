import 'package:flutter/material.dart';
import 'package:front_weteam/model/weteam_profile.dart';
import 'package:front_weteam/model/weteam_user.dart';
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

  Future<void> saveOrganization(String organization) async {
    WeteamUser user = Get.find<AuthService>().user.value!;
    // 서버에 요청하기 전, 변경사항을 로컬에 적용
    user.organization = organization;
    Get.find<AuthService>().user.refresh();

    // 서버에 저장합니다.
    // TODO: api 요청 실패에 대한 예외처리
    await Get.find<ApiService>().setUserOrganization(organization);
  }

  Future<void> saveProfile(int id) async {
    WeteamUser user = Get.find<AuthService>().user.value!;
    // 서버에 요청하기 전, 변경사항을 로컬에 적용
    user.profile = WeteamProfile(userId: user.profile!.userId, imageIdx: id);
    Get.find<AuthService>().user.refresh();

    // 서버에 프로필을 저장합니다.
    // TODO: api 요청 실패에 대한 예외처리
    await Get.find<ApiService>().changeUserProfiles(id);
  }

  /// 변경사항을 저장하는 메소드
  ///
  /// * 변경사항이 없는 경우 api 요청을 보내지 않습니다.
  /// * 변경사항이 있으면 서버로부터 유저 정보를 최신화합니다.
  Future<void> saveChanges() async {
    WeteamUser user = Get.find<AuthService>().user.value!;
    String organization = textController.text;
    int selectedProfileId = getSelectedProfileId() ?? 0;

    Future? organizationFuture;
    Future? profileFuture;

    // 소속이 바뀌었는지 확인합니다.
    if (_getUserOrganization() != organization) {
      organizationFuture = saveOrganization(organization);
    }

    // 프로필이 바뀌었는지 확인합니다.
    if (user.profile!.imageIdx != selectedProfileId) {
      profileFuture = saveProfile(selectedProfileId);
    }

    // 보낸 요청들이 끝날 때까지 기다립니다
    await organizationFuture;
    await profileFuture;

    // 변경사항이 있었다면, 서버로부터 유저 정보를 최신화합니다.
    if (organizationFuture != null && profileFuture != null) {
      // 유저 정보를 서버에서 불러옵니다.
      WeteamUser? updatedUser = await Get.find<ApiService>().getCurrentUser();
      // 서버에서 성공적으로 불러왔을 때만 적용합니다.
      if (updatedUser != null) {
        Get.find<AuthService>().user.value = updatedUser;
        Get.find<AuthService>().user.refresh();
      }
    }
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
