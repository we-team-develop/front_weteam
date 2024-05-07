import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../model/team_project.dart';

class TeamProjectService {
  final Map<int, RxTeamProject> _storage = {};

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
    if (entry == null) {
      entry = RxTeamProject(tp);
      _storage[tp.id] = entry;
    } else {
      TeamProject oldTp = entry.value;
      entry.value = tp;

      if (oldTp == tp) {
        entry.refresh();
      }
    }

    return entry;
  }

  void removeEntry(int id) {
    RxTeamProject? rtp = getTeamProjectById(id);
    if (rtp == null) return;

    rtp.close();
    _storage.remove(id);
  }

}

class RxTeamProject extends Rx<TeamProject>{
  RxBool _destroy = RxBool(false);

  RxTeamProject(super.initial) {
    TeamProjectService tps = Get.find<TeamProjectService>();

    // 이미 이 팀플에 대한 인스턴스가 존재한다면 예외 발생
    if (tps.getTeamProjectById(value.id) != null) {
      throw '이미 ${value.id}(${value.title}) Rx팀플 인스턴스가 존재합니다!';
    }
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
  @override
  void add(RxTeamProject element) {
    element.listenDestroyed((destroyed) {
      if (destroyed == false) {
        remove(element);
      }
    });
    super.add(element);
  }
}