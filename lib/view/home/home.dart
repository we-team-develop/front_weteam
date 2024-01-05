import 'package:flutter/material.dart';
import 'package:front_weteam/controller/mail_box_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/dialog/home/add_dday_dialog.dart';
import 'package:front_weteam/dialog/home/add_team_dialog.dart';
import 'package:front_weteam/dialog/home/check_remove_dday_dialog.dart';
import 'package:front_weteam/view/widget/app_title_widget.dart';
import 'package:front_weteam/view/widget/team_information_widget.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool hasFixedDDay = false;
  bool isTeamListEmpty = true; // TODO: 팀플 비어있는지 확인하기, Controller 만들기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ColoredBox(
            color: const Color(0xFFFFFFFF),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: _body())));
  }

  Widget _body() {
    return Column(
      children: [
        _head(),
        const SizedBox(
          height: 12,
        ),
        if (!hasFixedDDay)
          _noItemsCardWidget()
        else
          const DDayWidget(name: "모션그래픽 1차 마감일까지", leftDays: 1),
        if (!isTeamListEmpty)
          const SizedBox(
            height: 15,
          ),
        if (!isTeamListEmpty)
          const SizedBox(
            height: 0.7,
            width: double.infinity,
            child: ColoredBox(
              color: Color(0xFFD9D9D9),
            ),
          ),
        if (!isTeamListEmpty)
          const SizedBox(
            height: 15,
          ),
        _teamListWidget(),
        _bottomBanner(),
      ],
    );
  }

  Widget _head() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
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
              GestureDetector(
                onTap: () {
                  _showDialog(const AddDDayDialog());
                },
                child: Padding(
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
                    )),
              )
            ],
          ),
        ),
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
                  GestureDetector(
                    onTap: () {
                      _showDialog(const AddTeamDialog());
                    },
                    child: Image.asset(
                      ImagePath.icPlus,
                      height: 34,
                      width: 34,
                    ),
                  ),
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
    return Expanded(
        child: Column(
      children: [
        const Expanded(
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
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showDialog(const AddDDayDialog()),
          child: AspectRatio(
            aspectRatio: 330 / 49,
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagePath.icPlusSquareLight,
                    width: 21.22,
                    height: 21.22,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    '팀플 추가하기',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 11,
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
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
                        fontFamily: 'NanumSquareNeoBold',
                        fontWeight: FontWeight.w900,
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

  PopupMenuItem _menuItem(Widget widget) {
    return PopupMenuItem(
        padding: EdgeInsets.zero,
        child: Center(
          child: widget,
        ));
  }

  void _showDialog(Widget dialogWidget) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        //barrierDismissible: false,
        builder: (BuildContext context) {
          return dialogWidget;
        });
  }
}

class DDayWidget extends StatefulWidget {
  final String name;
  final int leftDays;

  const DDayWidget({super.key, required this.name, required this.leftDays});

  @override
  State<StatefulWidget> createState() {
    return _DDayWidgetState();
  }
}

class _DDayWidgetState extends State<DDayWidget> {
  bool showPopupMenu = false;

  @override
  Widget build(BuildContext context) {
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showPopupMenu = !showPopupMenu; // 활성화 상태 반전
                              });
                            },
                            child: ImageData(path: ImagePath.icKebabWhite),
                          ),
                          Visibility(
                            visible: showPopupMenu,
                            child: Container(
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x23000000),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: IntrinsicHeight(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          // 여백 터치 안 되는 문제 수정
                                          onTap: () {
                                            setState(() {
                                              showPopupMenu = false;
                                            });
                                          },
                                          child: const SizedBox(
                                            height: 21,
                                            child: Center(
                                              child: Text(
                                                '수정하기',
                                                style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 8,
                                                  fontFamily:
                                                      'NanumSquare Neo OTF',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          )),
                                      Container(
                                        width: 67,
                                        height: 0.50,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFEEEEEE)),
                                      ),
                                      GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          // 여백 터치 안 되는 문제 수정
                                          onTap: () {
                                            setState(() {
                                              showPopupMenu = false;
                                              showDialog(
                                                  context: context,
                                                  //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                                                  //barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const CheckRemoveDdayDialog();
                                                  });
                                            });
                                          },
                                          child: const SizedBox(
                                              height: 21,
                                              child: Center(
                                                child: Text(
                                                  '삭제하기',
                                                  style: TextStyle(
                                                    color: Color(0xFFE60000),
                                                    fontSize: 8,
                                                    fontFamily:
                                                        'NanumSquare Neo OTF',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ))),
                                    ],
                                  ),
                                )),
                          )
                        ],
                      ),
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
                            widget.name,
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
                        'D - ${widget.leftDays.toString().padLeft(3, '0')} ',
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
