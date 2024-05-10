import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/image_data.dart';
import '../../service/auth_service.dart';
import '../../service/team_project_service.dart';

class TeamPlayController extends GetxController {
  final ScrollController tpScrollController = ScrollController();

  // 팀플 목록
  late RxTeamProjectList tpList;

  // 팀플 이미지
  final RxList<String> imagePaths = RxList<String>([
    ImagePath.tpImage1,
    ImagePath.tpImage2,
    ImagePath.tpImage3,
    ImagePath.tpImage4,
    ImagePath.tpImage5,
    ImagePath.tpImage6,
    ImagePath.tpImage7,
    ImagePath.tpImage8,
    ImagePath.tpImage9,
    ImagePath.tpImage10,
  ]);

  @override
  void onInit() {
    TeamProjectService tpService = Get.find<TeamProjectService>();
    tpList = tpService.notDoneList;
    super.onInit();
  }

  /// 팀플 목록을 최상단으로 스크롤합니다.
  void tpScrollUp() {
    tpScrollController.animateTo(0,
        duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
  }

  /// 현재 로그인된 유저의 이름을 불러옵니다.
  String getUserName() {
    return Get.find<AuthService>().user.value?.username ?? "";
  }

  Future<bool> updateTeamProjectList() async {
    TeamProjectService tpService = Get.find<TeamProjectService>();
    return tpService.updateNotDoneList();
  }
}
