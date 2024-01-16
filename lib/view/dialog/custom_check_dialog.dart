import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCheckDialog extends StatelessWidget {
  final String title; // 예시: 정말 로그아웃 하시겠습니까?
  final String content; // 예시: 다시 돌아올 거라 믿어요😢
  final String denyName;
  final String admitName;
  final int denyColorInt;
  final int admitColorInt;
  final Function()? denyCallback;
  final Function()? admitCallback;

  const CustomCheckDialog(
      {super.key,
      required this.title,
      required this.content,
      this.denyName = '아니오',
      this.admitName = '네',
      this.denyColorInt = 0xFF333333, // (약) 검정
      this.admitColorInt = 0xFFE60000, // 붉은 색
      this.denyCallback,
      this.admitCallback});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.fromLTRB(40, 28, 40, 5),
      backgroundColor: const Color(0xFFFFFFFF),
      surfaceTintColor: const Color(0xFFFFFFFF),
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //Dialog Main Title
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF333333),
          fontSize: 12,
          fontFamily: 'NanumSquareNeo',
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min, // 최소 크기로
        crossAxisAlignment: CrossAxisAlignment.center, // 가운데 정렬
        children: [
          Text(content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 10,
                fontFamily: 'NanumSquareNeo',
                fontWeight: FontWeight.w400,
              )),

          const SizedBox(height: 12.37),
          // Divider
          Container(
            width: double.infinity,
            height: 0.5,
            decoration: const BoxDecoration(
              color: Color(0xFFDCDCDC),
            ),
          ),
          IntrinsicHeight(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Button(name: denyName, colorInt: denyColorInt, callback: denyCallback),
              Container(
                width: 0.5,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCDCDC),
                ),
              ),
              _Button(name: admitName, colorInt: admitColorInt, callback: admitCallback)
            ],
          )),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String name;
  final int colorInt;
  final Function? callback;
  final Rx<bool> loading = false.obs; // 로딩 여부 확인

  _Button({required this.name, required this.colorInt, this.callback});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => callCallback(),
        //behavior: HitTestBehavior.translucent, // 모든 곳 터치 되도록
        child: Center(
          child: Obx(
            () => loading.value ? const CircularProgressIndicator() : Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(colorInt),
                fontSize: 12,
                fontFamily: 'NanumSquareNeo',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void callCallback() async {
    if (callback == null && loading.value) {
      return;
    }

    loading.value = true; // 로딩 상태 true
    loading.refresh(); // 조금 더 확실하게 update

    try {
      dynamic ret = callback!.call();
      if (ret is Future) await ret; // 비동기 함수일경우 await
    } catch (e, st) {
      debugPrint("$e");
      debugPrintStack(stackTrace: st);
    }

    loading.value = false;
    loading.refresh();
  }

}