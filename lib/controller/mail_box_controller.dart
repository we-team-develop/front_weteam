import 'package:front_weteam/model/mail_box.dart';
import 'package:get/get.dart';

class MailBoxController extends GetxController { // 홈 화면에 있는 알림 아이콘
  final Rx<MailBox> mailBox = MailBox().obs;

  void updateHasNew(hasNew) {
    mailBox.update((val) {
      val?.hasNew = hasNew;
    });
  }

  void addNotification() {} // TODO: 서버 API가 만들어지면 구현
}