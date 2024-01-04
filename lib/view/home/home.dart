import 'package:flutter/material.dart';
import 'package:front_weteam/controller/mail_box_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/view/widget/team_information_widget.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List ddayItems = [];
  int currentSliderIndex = 0;
  bool isTeamListEmpty = true; // TODO: 팀플 비어있는지 확인하기, Controller 만들기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: ColoredBox(color: const Color(0xFFFFFFFF), child: _body())));
  }

  Widget _body() {
    return Column(
      children: [
        _head(),
        const SizedBox(
          height: 12,
        ),
        if (ddayItems.isEmpty)
          _noItemsCardWidget()
        else
          _ddayWidget("모션그래픽 1차 마감일까지", 1),
        const SizedBox(
          height: 15,
        ),
        _indexIconList(),
        if (!isTeamListEmpty) const SizedBox(
          height: 15,
        ),
        if (!isTeamListEmpty) const Divider(
          color: Color(0xFFedecec),
          thickness: 0.7,
        ),
        if (!isTeamListEmpty) const SizedBox(
          height: 25,
        ),
        _teamListWidget(),
        _bottomBanner(),
      ],
    );
  }

  Widget _head() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [const AppTitleWidget(), _bellIcon()],
    );
  }

  Widget _bellIcon() {
    return GetX<MailBoxController>(
        init: MailBoxController(),
        builder: (_) => Container(
            width: 24.65,
            height: 22.99,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: Image.asset(Get.find<MailBoxController>().mailBox().hasNew
                ? ImagePath.bellIconNew
                : ImagePath.bellIcon)));
  }

  Widget _noItemsCardWidget() {
    return AspectRatio(
      aspectRatio: 330 / 176,
      child: Container(
/*        width: 330,
        height: 176,*/
        decoration: ShapeDecoration(
          color: const Color(0xFFFFF2EF),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE4E4E4)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
/*        width: 330,
        height: 176,*/
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '중요한 일정을 ',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 11,
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '추가',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 11,
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '해보세요!\n언제든 수정가능합니다:)',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 11,
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 72),
                  child: AspectRatio(
                    aspectRatio: 185 / 24,
                    child: Container(
                      decoration: ShapeDecoration(
                        color: const Color(0xFFE2583E),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Center(
                        child: Text(
                          '중요 일정 추가하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'NanumGothicOTF',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _indexIconList() {
    if (ddayItems.isEmpty) return const SizedBox(height: 0); // 표시 안 함

    return ListView.builder(
      itemBuilder: (context, index) {
        bool enabled = currentSliderIndex == index;
        return _indexIcon(enabled);
      },
      itemCount: ddayItems.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  Widget _indexIcon(bool enabled) {
    return Container(
      width: 7,
      height: 7,
      decoration: ShapeDecoration(
        color: enabled ? const Color(0xFF969696) : const Color(0xffe5e5e5),
        shape: const OvalBorder(),
      ),
    );
  }

  Widget _teamListWidget() {
    // TODO: 데이터 형식에 맞게 ListView.builder 사용
    if (isTeamListEmpty) {
      return Expanded(
          child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImagePath.icPlus, height: 34, width: 34,),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    '진행 중인  팀플이 없어요.\n지금 바로 생성해보세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 11,
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 0,
              child: Image.asset(
                ImagePath.emptyTimiIcon,
                width: 75.55,
                height: 96,
              ),
            )
          ],
        ),
      ));
    }
    return const Expanded(
        child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TeamInformationWidget(
                    img: "",
                    title: '모션그래픽기획및제작',
                    description: '기말 팀 영상 제작',
                    memberSize: 4,
                    date: '2023.10.05~ 2024.12.08'),
                TeamInformationWidget(
                    img: "",
                    title: '실감미디어콘텐츠개발',
                    description: '기말 팀 프로젝트 : Unity AR룰러앱 제작',
                    memberSize: 4,
                    date: '2023.10.05~ 2024.12.19'),
                TeamInformationWidget(
                    img: "",
                    title: '머신러닝의이해와실제',
                    description: '머신러닝 활용 프로그램 제작 프로젝트',
                    memberSize: 2,
                    date: '2023.11.28~ 2024.12.08'),
                TeamInformationWidget(
                    img: "",
                    title: '빽스타2기',
                    description: '빽다방서포터즈 팀작업',
                    memberSize: 4,
                    date: '2023.07.01~ 2024.10.01'),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 21,
        ),
      ],
    ));
  }

  Widget _bottomBanner() {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: ShapeDecoration(
        color: const Color(0xFFFFF1EF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      '빠르고 간단하게 팀플 약속잡기!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 8,
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '언제보까? 바로가기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w800,
                        height: 0,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 16,
            child: Image.asset(
              ImagePath.bottomBannerIcon,
              width: 44,
              height: 63,
            ),
          )
        ],
      ),
    );
  }

  Widget _ddayWidget(String name, int leftDays) {
    String formattedDDay = leftDays.toString().padLeft(3, '0');
    return AspectRatio(
        aspectRatio: 330 / 176,
        child: Container(
            decoration: ShapeDecoration(
              color: const Color(0xFFE2583E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          throw UnimplementedError(); // TODO: 메뉴 구현
                        },
                        child: ImageData(path: ImagePath.icKebabWhite),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            ImagePath.icPinWhite,
                            height: 10,
                            width: 10,
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'NanumSquareNeo',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          )
                        ],
                      ),
                      Text(
                        'D - $formattedDDay ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 52,
                          fontFamily: 'Cafe24Moyamoya',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )));
  }
}
