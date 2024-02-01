import 'package:get/get.dart';

import '../service/api_service.dart';

class WTMController extends GetxController {
  final Rxn<GetWTMProjectListResult> wtmList = Rxn<GetWTMProjectListResult>();
  RxString selectedtpList = '진행중인 팀플'.obs;

  void setSelectedtpList(String tpList) {
    selectedtpList.value = tpList;
  }
}
