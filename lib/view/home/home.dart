import 'package:flutter/material.dart';
import 'package:front_weteam/controller/home_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/view/dialog/home/add_dday_dialog.dart';
import 'package:front_weteam/view/dialog/home/add_team_dialog.dart';
import 'package:front_weteam/view/dialog/home/check_remove_dday_dialog.dart';
import 'package:front_weteam/view/widget/app_title_widget.dart';
import 'package:front_weteam/view/widget/normal_button.dart';
import 'package:front_weteam/view/widget/team_information_widget.dart';
import 'package:get/get.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(15.0), child: _body());
  }

  Widget _body() {
    return Column(
      children: [
        _head(),
        const SizedBox(
          height: 12,
        ),
        const DDayWidget(),
        ...getTeamListBody(),
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

  List<Widget> getTeamListBody() {
    List<Widget> ret = [];

    if (!controller.isTeamListEmpty()) { // 표시할 팀플이 있는지 확인
      ret.add(const SizedBox(height: 15));
      ret.add(const SizedBox(
        height: 0.7,
        width: double.infinity,
        child: ColoredBox(
          color: Color(0xFFD9D9D9),
        ),
      ));
      ret.add(const SizedBox(height: 15));
    }

    return ret;
  }

  Widget _bellIcon() {
    return Image.asset(
            width: 24.65,
            height: 22.99,
            controller.hasNewNotification()
                ? ImagePath.icBellNew
                : ImagePath.icBell);
  }

  Widget _teamListWidget() {
    // TODO: 데이터 형식에 맞게 ListView.builder 사용
    if (controller.isTeamListEmpty()) {
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
                      controller.popupDialog(const AddTeamDialog());
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
                ImagePath.icEmptyTimi,
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: getTeamListExample(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => controller.popupDialog(const AddDDayDialog()),
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

  List<TeamInformationWidget> getTeamListExample() {
    return [
      const TeamInformationWidget(
          img: "",
          title: '모션그래픽기획및제작',
          description: '기말 팀 영상 제작',
          memberSize: 4,
          date: '2023.10.05~ 2024.12.08'),
      const TeamInformationWidget(
          img: "",
          title: '실감미디어콘텐츠개발',
          description: '기말 팀 프로젝트 : Unity AR룰러앱 제작',
          memberSize: 4,
          date: '2023.10.05~ 2024.12.19'),
      const TeamInformationWidget(
          img: "",
          title: '머신러닝의이해와실제',
          description: '머신러닝 활용 프로그램 제작 프로젝트',
          memberSize: 2,
          date: '2023.11.28~ 2024.12.08'),
      const TeamInformationWidget(
          img: "",
          title: '빽스타2기',
          description: '빽다방서포터즈 팀작업',
          memberSize: 4,
          date: '2023.07.01~ 2024.10.01'),
    ];
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
}

class DDayWidget extends StatefulWidget {
  const DDayWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DDayWidgetState();
  }
}

class _DDayWidgetState extends State<DDayWidget> {
  bool showPopupMenu = false;
  Map? dday;

  _DDayWidgetState() {
    dday = Get.find<HomeController>().getDDay();
  }

  @override
  Widget build(BuildContext context) {
    if (Get.find<HomeController>().hasFixedDDay()) {
      return _ddayWidget();
    } else {
      return _noDDayWidget();
    }
  }

  Widget _ddayWidget() {
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
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const AddDDayDialog(); // TODO: D-Day 수정 Dialog 만들기
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
                                                  'NanumSquareNeo',
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
                                                    'NanumSquareNeo',
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
                            dday?['name'],
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
                        'D - ${dday?['leftDays'].toString().padLeft(3, '0')} ',
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

  Widget _noDDayWidget() {
    return AspectRatio(
      aspectRatio: 330 / 176,
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFFFFF2EF),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE4E4E4)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
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
              NormalButton(text: '중요 일정 추가하기', onTap: () => Get.find<HomeController>().popupDialog(const AddDDayDialog())),
            ],
          ),
        ),
      ),
    );
  }
}