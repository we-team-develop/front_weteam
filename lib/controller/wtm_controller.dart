import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/model/weteam_user.dart';
import 'package:front_weteam/service/api_service.dart';
import 'package:front_weteam/service/auth_service.dart';
import 'package:get/get.dart';

class WTMController extends GetxController {
  final Rxn<GetWTMProjectListResult> wtmList = Rxn<GetWTMProjectListResult>();
  final Rxn<TeamProject> selectedTeamProject = Rxn();
  final RxList<TeamProject> tpList = RxList();
  RxString selectedtpList = '진행중인 팀플'.obs;

  void setSelectedtpList(String tpList) {
    selectedtpList.value = tpList;
    bool done = tpList == "완료된 팀플";
    updateTeamProject(done);
    selectedTeamProject.value = null;
    selectedTeamProject.refresh();
  }

  Future<void> updateTeamProject(bool done) async {
    WeteamUser user = Get.find<AuthService>().user.value!;
    tpList.clear();
    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(0, done, 'DESC', 'DONE', user.id);

    if (result != null) {
      tpList.addAll(result.projectList);
    } else {
      Get.snackbar('문제가 발생했습니다', '팀플 목록을 불러오지 못했습니다');
    }
  }
}
