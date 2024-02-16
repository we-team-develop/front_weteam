import '../service/api_service.dart';
import 'package:get/get.dart';

import '../model/wtm_project.dart';

class WTMCurrentController extends GetxController {
  late final Rx<WTMProject> wtm;

  WTMCurrentController(WTMProject team) {
    wtm = team.obs;
    fetchWTMProject();
  }

  Future<void> fetchWTMProject() async {
    ApiService service = Get.find<ApiService>();
    WTMProject? wtm = await service.getWTMProject(this.wtm.value.id);
    if (wtm != null) {
      this.wtm.value = wtm;
    }
  }
}
