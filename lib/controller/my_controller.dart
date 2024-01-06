import 'package:get/get.dart';

class MyController extends GetxController {
  String getUserName() {
    return "차혜빈";
  }

  String getUserDescription() {
    return "미입력";
  }

  String getUserImgUrl() {
    throw UnimplementedError();
  }

  bool hasCompletedTeamProjects() {
    return true;
  }
}