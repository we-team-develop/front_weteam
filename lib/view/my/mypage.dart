import 'package:flutter/widgets.dart';
import 'package:front_weteam/controller/my_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/view/widget/app_title_widget.dart';
import 'package:front_weteam/view/widget/team_information_widget.dart';
import 'package:get/get.dart';

class MyPage extends GetView<MyController> {
  final double padding = 15;

  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: const Color(0xFFFFFFFF), child:CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _body(),
        )
      ],
    ));
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,

      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _head(),
        const SizedBox(height: 16.0),
        _profileContainer(),
        const SizedBox(height: 22),
        _bottomContainer(),
      ],
    );
  }

  Widget _head() {
    return Padding(
        padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
        child: const AppTitleWidget());
  }

  Widget _profileContainer() {
    return AspectRatio(
        aspectRatio: 360 / 135,
        child: Container(
          decoration: const BoxDecoration(color: Color(0xFFFFF2EF)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 37.0),
              Container(
                width: 82,
                height: 82,
                decoration: const ShapeDecoration(
                  color: Color(0xFFC4C4C4),
                  shape: OvalBorder(),
                ),
              ),
              const SizedBox(width: 33),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${controller.getUserName()}님 ',
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 16,
                          fontFamily: 'NanumGothic',
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                      Image.asset(ImagePath.icRightGray30,
                          width: 15, height: 15)
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    controller.getUserDescription(),
                    style: const TextStyle(
                      color: Color(0xFF7E7E7E),
                      fontSize: 10,
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget _bottomContainer() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize.max,
        children: [
          _bottomContainerTitle(),
          controller.hasCompletedTeamProjects()
              ? _bottomContainerTeamListWidget()
              : _bottomContainerEmpty()
        ],
      ),
    ));
  }

  Widget _bottomContainerTitle() {
    String text;

    if (controller.hasCompletedTeamProjects()) {
      text = "${controller.getUserName()}님이 완료한 팀플들이에요!";
    } else {
      text = "${controller.getUserName()}님은 완료한 팀플이 없어요!";
    }

    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 14,
        fontFamily: 'NanumGothic',
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _bottomContainerTeamListWidget() {
    List<Widget> list = [];

    for (int i = 0; i < 20; i++) {
      list.add(const TeamInformationWidget(
          title: '앱디져🔥🔥🔥',
          description: '앱디자인 강의 패러디앱 디자인 제작',
          memberSize: 3,
          date: '2023.01.02~ 2023.06.31'));
    }

    return Column(
      children: [
        // 예시입니다
        const SizedBox(height: 24),
        ...list
      ],
    );
  }

  Widget _bottomContainerEmpty() {
    return Expanded(
        child: Center(
            child: Image.asset(
      ImagePath.myNoTeamProjectTimi,
      width: 113.37,
      height: 171.44,
    )));
  }
}
