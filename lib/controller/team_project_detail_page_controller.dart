import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/model/weteam_project_user.dart';
import 'package:front_weteam/service/api_service.dart';
import 'package:get/get.dart';

class TeamProjectDetailPageController extends GetxController {
  late final Rx<TeamProject> teama;
  Rx<List<WeteamProjectUser>> userList = Rx<List<WeteamProjectUser>>([]);

  TeamProjectDetailPageController(TeamProject team) {
    teama = team.obs;
    fetchUserList();
  }

  // 성공 여부 반환
  Future<bool> fetchUserList() async {
    List<WeteamProjectUser>? list = await Get.find<ApiService>().getProjectUsers(teama.value.id);
    if (list == null || list.isEmpty) return false; // 비어있으면 서버 오류로 판단

    userList.value = list;
    return true;
  }
}