import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/service/api_service.dart';
import 'package:get/get.dart';

class WTMController extends GetxController {
  final Rxn<GetWTMProjectListResult> wtmList = Rxn<GetWTMProjectListResult>();
  final RxList<TeamProject> tpList = RxList();
  RxString selectedtpList = '진행중인 팀플'.obs;

  void setSelectedtpList(String tpList) {
    selectedtpList.value = tpList;
    bool done = tpList == "완료된 팀플";
    updateTeamProject(done);
  }

  Future<void> updateTeamProject(bool done) async {
    tpList.clear();
    GetTeamProjectListResult? result = await Get.find<ApiService>()
        .getTeamProjectList(0, done, 'desc', 'done');
    if (result != null) {
      tpList.addAll(result.projectList);
    }
  }

  @override
  void onInit() {
    super.onInit();
    setSelectedtpList(selectedtpList.value);
  }
}
