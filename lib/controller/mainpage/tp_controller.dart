import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/image_data.dart';
import '../../main.dart';
import '../../model/team_project.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';

class TeamPlayController extends GetxController {
  final ScrollController tpScrollController = ScrollController();
  // 팀플 목록
  final Rxn<GetTeamProjectListResult> tpList = Rxn<GetTeamProjectListResult>();
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

  /// 마지막으로 업데이트된 팀플 목록. 팀플 목록 업데이트시 변경사항이 있는지 확인할 때 사용합니다.
  List<TeamProject> _oldTpList = [];

  @override
  void onInit() {
    if (Get.find<AuthService>().user.value != null) {
      updateTeamProjectList();
    }
    tpListUpdateRequiredListenerList.add(updateTeamProjectList);
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

  /// 팀플 목록을 업데이트합니다.
  Future<void> updateTeamProjectList() async {
    // 캐시된 데이터 가져오기
    String? json = sharedPreferences
        .getString(SharedPreferencesKeys.teamProjectNotDoneListJson);
    if (json != null) { // 데이터가 있는 경우
      tpList.value = GetTeamProjectListResult.fromJson(jsonDecode(json));
      _oldTpList = tpList.value!.projectList;
    }

    // api호출 및 결과
    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(
            0, false, 'DESC', 'DONE', Get.find<AuthService>().user.value!.id,
            cacheKey: SharedPreferencesKeys.teamProjectNotDoneListJson);

    // 팀플 목록에 수정사항이 있는지 확인
    if (result != null && !listEquals(_oldTpList, result.projectList)) {
      _oldTpList = result.projectList;
      tpList.value = result;
    }
  }
}
