import 'dart:convert';
import 'dart:io';

// ignore: unused_import
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/team_project.dart';
import 'api_service.dart';
import 'auth_service.dart';

class TeamProjectService extends GetxService{
  final Map<int, RxTeamProject> _storage = {};
  final RxTeamProjectList doneList = RxTeamProjectList();
  final RxTeamProjectList notDoneList = RxTeamProjectList();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 1), () async {
      while (!initialized) {
        sleep(const Duration(milliseconds: 10));
      }
      Get.find<AuthService>().isLoggedIn();
      await _updateListsFromCache();
      await updateLists();
    });
  }

  Future<void> _updateListsFromCache() async {
    String doneCacheKey = SharedPreferencesKeys.teamProjectDoneListJson;
    String notDoneCacheKey = SharedPreferencesKeys.teamProjectNotDoneListJson;

    String? doneListCache = sharedPreferences.getString(doneCacheKey);
    String? notDoneListCache = sharedPreferences.getString(notDoneCacheKey);

    if (doneListCache != null) {
      GetTeamProjectListResult gtplResult =
      GetTeamProjectListResult.fromJson(jsonDecode(doneListCache), true);
      doneList.clear();
      doneList.addAll(gtplResult.rxProjectList);
    }

    if (notDoneListCache != null) {
      GetTeamProjectListResult gtplResult =
      GetTeamProjectListResult.fromJson(jsonDecode(notDoneListCache), true);
      doneList.clear();
      doneList.addAll(gtplResult.rxProjectList);
    }
  }

  Future<bool> updateDoneList() async {
    String cacheKey = SharedPreferencesKeys.teamProjectDoneListJson;

    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(
        0, true, 'DESC', 'DONE', Get.find<AuthService>().user.value!.id,
        cacheKey: cacheKey);

    if (result != null) {
      doneList.value = result.rxProjectList;
      doneList.refresh();
    }

    return result != null;
  }

  Future<bool> updateNotDoneList() async {
    String cacheKey = SharedPreferencesKeys.teamProjectDoneListJson;

    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(
        0, false, 'DESC', 'DONE', Get.find<AuthService>().user.value!.id,
        cacheKey: cacheKey);

    if (result != null) {
      notDoneList.value = result.rxProjectList;
      notDoneList.refresh();
    }

    return result != null;
  }

  Future<bool> updateLists() async {
    Set<int> idSet = {};
    for (RxTeamProject rtp in doneList) {
      idSet.add(rtp.value.id);
    }
    for (RxTeamProject rtp in notDoneList) {
      idSet.add(rtp.value.id);
    }

    Future<bool> df = updateDoneList();
    Future<bool> ndf = updateNotDoneList();

    bool dfSuccess = await df;
    bool ndfSuccess = await ndf;

    // Clean
    Set<int> newIdSet = {};
    for (RxTeamProject rtp in doneList) {
      newIdSet.add(rtp.value.id);
    }
    for (RxTeamProject rtp in notDoneList) {
      newIdSet.add(rtp.value.id);
    }

    idSet.removeAll(newIdSet);
    for (int toRemoveId in idSet) {
      removeEntry(toRemoveId);
    }

    return dfSuccess && ndfSuccess;
  }

  // HashedId를 사용하여 팀플을 찾습니다
  RxTeamProject? getTeamProjectByHashedId(String hashedId) {
    for (RxTeamProject entry in _storage.values) {
      if (entry.value.hashedId == hashedId) {
        return entry;
      }
    }

    return null;
  }

  RxTeamProject? getTeamProjectById(int id) {
    return _storage[id];
  }

  // 이미 존재하면 업데이트, 없으면 생성
  RxTeamProject updateEntry(TeamProject tp) {
    RxTeamProject? entry = getTeamProjectById(tp.id);
    bool addToList = true;

    if (entry == null) {
      entry = RxTeamProject(tp);
      _storage[tp.id] = entry;
    } else {
      TeamProject oldTp = entry.value;
      entry.value = tp;

      if (oldTp == tp) {
        entry.refresh();
      }

      if (oldTp.done == tp.done) {
        addToList = false;
      }
    }

    if (addToList) {
      if (tp.done) {
        doneList.add(entry);
        notDoneList.removeById(tp.id);
      } else {
        notDoneList.add(entry);
        doneList.removeById(tp.id);
      }
    }

    return entry;
  }

  void removeEntry(int id) {
    RxTeamProject? rtp = getTeamProjectById(id);
    if (rtp == null) return;

    if (rtp.value.done) {
      doneList.remove(rtp);
    } else {
      notDoneList.remove(rtp);
    }

    _storage.remove(id);
  }
}

class RxTeamProject extends Rx<TeamProject>{
  final RxBool _destroy = RxBool(false);

  RxTeamProject(super.initial) {
    TeamProjectService tps = Get.find<TeamProjectService>();

    // 이미 이 팀플에 대한 인스턴스가 존재한다면 예외 발생
    if (tps.getTeamProjectById(value.id) != null) {
      throw '이미 ${value.id}(${value.title}) Rx팀플 인스턴스가 존재합니다!';
    }
  }

  factory RxTeamProject.updateOrCreate(TeamProject tp) {
    TeamProjectService tps = Get.find<TeamProjectService>();

    RxTeamProject? rtp = tps.getTeamProjectById(tp.id);
    if (rtp != null) {
      return tps.updateEntry(tp);
    }

    return RxTeamProject(tp);
  }

  bool isDestroyed() {
    return _destroy.value;
  }

  void listenDestroyed(Function(bool) callBack) {
    _destroy.listen(callBack);
  }

  @override
  void close() {
    _destroy.value = true;
    super.close();
  }

/*  @override
  TeamProject get value{
    if (_destroy.isFalse) {
      throw '삭제된 팀플(${value.id}이(가) 사용되었습니다!';
    }
    return super.value;
  }*/
}

class RxTeamProjectList extends RxList<RxTeamProject> {
  final Map<int, RxTeamProject> _map = {};

  @override
  void add(RxTeamProject element) {
    element.listenDestroyed((destroyed) {
      if (destroyed == false) {
        remove(element);
      }
    });
    int id = element.value.id;
    if (_map[id] != null) remove(_map[id]);
    _map[element.value.id] = element;
    super.add(element);
  }

  void removeById(int id) {
    remove(_map[id]);
  }
}