import 'package:flutter/cupertino.dart';
import 'package:front_weteam/view/dialog/custom_check_dialog.dart';
import 'package:get/get.dart';

class CheckRemoveDdayDialog extends StatelessWidget {
  const CheckRemoveDdayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCheckDialog(
      title: "정말 삭제하시겠습니까?",
      content: "해당 디데이는 완전히 삭제됩니다",
      denyName: "취소",
      admitName: "삭제",
      admitCallback: () => Get.back(),
      denyCallback: () => Get.back(),
    );
  }
}
