import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/color_data.dart';
import '../data/image_data.dart';
import '../model/weteam_profile.dart';
import '../model/weteam_user.dart';
import '../service/api_service.dart';
import '../service/auth_service.dart';

class ProfileController extends GetxController {
  /// 프로필 티미 이미지 목록
  final RxList<String> imagePaths = RxList<String>([
    ImagePath.profile1,
    ImagePath.profile2,
    ImagePath.profile3,
    ImagePath.profile4,
    ImagePath.profile5,
    ImagePath.profile6,
  ]);

  /// 프로필 배경 목록
  final RxList<Color> backgroundColors = RxList<Color>([
    AppColors.purple,
    AppColors.blue2,
    AppColors.pink1,
    AppColors.blue1,
    AppColors.yellow1,
    AppColors.pink2,
  ]);

  /// 프로필 선택 여부 리스트
  var isSelectedList = List.generate(6, (index) => false).obs;

  /// 푸쉬 알림 토글 활성화 여부
  RxBool isPushNotificationEnabled = false.obs;

  /// 소속 입력칸에 대한 TextEditingController
  final TextEditingController organizationTextEditingController = TextEditingController();
  /// 소속 입력칸에 입력된 값의 글자 수
  final RxInt textLength = 0.obs;
  final RxBool changes = RxBool(false);


  /// 컨트롤러가 초기화될 때 실행됩니다.
  @override
  void onInit() {
    super.onInit();
    // 소속 입력칸의 값이 변경되면 textLength 변수를 업데이트하고, 변경사항이 있는지 확인.
    organizationTextEditingController.addListener(() async {
      textLength.value = organizationTextEditingController.text.length;
      changes.value = anyChanges();
    });

    // 프로필 선택이 바뀌면 변경사항이 있는지 확인합니다.
    isSelectedList.listen((p0) {
      changes.value = anyChanges();
    });
  }

  @override
  void onClose() {
    organizationTextEditingController.dispose();
    super.onClose();
  }

  /// 프로필 선택하는 메소드입니다. 프로필 선택시 기존에 선택된 프로필은 선택 해제됩니다.
  void selectProfile(int index) {
    Future.microtask(() {
      for (int i = 0; i < isSelectedList.length; i++) {
        bool selected = i.isEqual(index);
        isSelectedList[i] = selected;
      }

      // 목록이 수정되었음을 알립니다.
      isSelectedList.refresh();
    });
  }

  /// 선택된 프로필 이미지의 인덱스를 받습니다. 선택된 프로필이 없을 경우 null을 받습니다.
  int? getSelectedProfileId() {
    for (int i = 0; i < isSelectedList.length; i++) {
      if (isSelectedList[i]) return i;
    }

    return null;
  }

  /// 푸시 알림 토글의 값을 변경합니다.
  void togglePushNotification(bool value) {
    isPushNotificationEnabled.value = value;
  }

  /// 현재 유저의 소속을 얻습니다.
  String _getUserOrganization() {
    String? organization = Get.find<AuthService>().user.value?.organization;
    if (organization == null || organization.trim().isEmpty) {
      return "";
    }
    return organization;
  }

  /// 현재 유저의 소속을 소속 입력 텍스트 필드에 적용합니다.
  void updateOrganization() {
    organizationTextEditingController.text = _getUserOrganization();
  }

  /// 입력된 소속 값을 서버에 저장합니다.
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

  /// checkAnyChanges
  ///
  /// description:
  /// 프로필 사진이나 소속 중 어느 하나라도 변경사항이 있는지 확인합니다.
  ///
  /// return: true - 변경사항이 있음
  ///         false - 변경사항이 없음
  bool anyChanges() {
    ////////////// 소속 변경 사항 확인 //////////////
    String org = organizationTextEditingController.text;
    bool orgChanged = _getUserOrganization() != org;

    ////////////// 프로필 사진 변경 사항 확인 //////////////
    int selectedProfileId = getSelectedProfileId() ?? 0;
    WeteamUser user = Get.find<AuthService>().user.value!;
    bool prfChanged = user.profile!.imageIdx != selectedProfileId;

    return orgChanged || prfChanged;
  }

  /// 변경사항을 저장하는 메소드
  ///
  /// * 변경사항이 없는 경우 api 요청을 보내지 않습니다.
  /// * 변경사항이 있으면 서버로부터 유저 정보를 최신화합니다.
  Future<void> saveChanges() async {
    // 저장할 변경사항이 없다면 함수 종료
    if (!anyChanges()) {
      return;
    }

    WeteamUser user = Get.find<AuthService>().user.value!;
    String organization = organizationTextEditingController.text;
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
}
