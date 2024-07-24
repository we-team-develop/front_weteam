import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../model/weteam_user.dart';
import '../../service/api_service.dart';
import '../../service/team_project_service.dart';

abstract class UserInfoController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late Rxn<WeteamUser> user;
  late RxTeamProjectList rxTpList;

  UserInfoController(this.user) {
    _init();
    updateTeamProjectList();
  }

  void _init() {
    _initTpList();
  }

  void scrollUp();

  bool isOtherUser();

  Future<bool> updateTeamProjectList();

  void _initTpList();
}

class MyInfoController extends UserInfoController {
  MyInfoController(super.user);

  @override
  Future<bool> updateTeamProjectList() {
    return Get.find<TeamProjectService>().updateDoneList();
  }

  @override
  bool isOtherUser() {
    return false;
  }

  @override
  void _initTpList() {
    rxTpList = Get.find<TeamProjectService>().doneList;
  }

  @override
  void scrollUp() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
  }
}

class OtherUserInfoController extends UserInfoController {
  OtherUserInfoController(super.user);

  @override
  bool isOtherUser() {
    return true;
  }

  @override
  Future<bool> updateTeamProjectList() async {
    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(
        0, true, 'DESC', 'DONE', user.value!.id);

    if (result == null) return false;
    rxTpList.value = result.rxProjectList;
    rxTpList.refresh();

    return true;
  }

  @override
  void _initTpList() {
    rxTpList = RxTeamProjectList();
  }

  @override
  void scrollUp() {
    throw "scrollUp이 잘못 사용됨!";
  }
}
