import 'package:front_weteam/service/auth_service.dart';
import 'package:get/get.dart';

class WeteamAuthProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();

    httpClient
    ..baseUrl = 'http://15.164.221.170:9090/'
    ..timeout = const Duration(seconds: 15);
  }

  Map<String, String> getHeader() {
    Map<String, String> headers = {'Authorization': 'Bearer ${Get.find<AuthService>().token}'};

    return headers;
  }

  // TODO: User 모델로 넘겨주기
  Future getCurrentUser() async {
    return await get('http://15.164.221.170:9090/api/users', headers: getHeader());
  }
}