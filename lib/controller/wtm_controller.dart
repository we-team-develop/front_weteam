import 'package:front_weteam/service/api_service.dart';
import 'package:get/get.dart';

class WTMController extends GetxController {
  final Rxn<GetWTMProjectListResult> wtmList = Rxn<GetWTMProjectListResult>();
  RxString selectedtpList = '진행중인 팀플'.obs;

  void setSelectedtpList(String tpList) {
    selectedtpList.value = tpList;
  }
}
