import 'package:flutter/material.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List ddayItems = [];
  int currentSliderIndex = 0;

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
        if (ddayItems.isEmpty) _noItemsCardWidget() else
          const SizedBox(),
        const SizedBox(
          height: 15,
        ),
        _indexIconList(),
        const SizedBox(
          height: 15,
        ),
        const Divider(
          color: Color(0xFFedecec),
          thickness: 0.7,
        ),
        const SizedBox(
          height: 25,
        ),
        _teamListWidget(),
        const SizedBox(
          height: 21,
        ),
        _bottomBanner(),
      ],
    );
  }

  Widget _head() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_title(), _bellIcon()],
    );
  }

  Widget _title() {
    return const Text(
      'WE TEAM',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF333333),
        fontSize: 16,
        fontFamily: 'SBaggroB',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

  Widget _bellIcon() {
    return Container(
        width: 24.65,
        height: 22.99,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: Image.asset(ImagePath.bellIcon));
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
                        fontFamily: 'NanumSquare Neo OTF',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '추가',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 11,
                        fontFamily: 'NanumSquare Neo OTF',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '해보세요!\n',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 11,
                        fontFamily: 'NanumSquare Neo OTF',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '최대 3개의 일정',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 11,
                        fontFamily: 'NanumSquare Neo OTF',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '까지 설정 가능합니다:) ',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 11,
                        fontFamily: 'NanumSquare Neo OTF',
                        fontWeight: FontWeight.w400,
                        height: 0,
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
    if (ddayItems.isEmpty) return _indexIcon(true); // 비어 있으면 점 하나

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
    return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _teamWidget(
                  "", '모션그래픽기획및제작', '기말 팀 영상 제작', 4, '2023.10.05~ 2024.12.08'),
              _teamWidget("", '실감미디어콘텐츠개발', '기말 팀 프로젝트 : Unity AR룰러앱 제작', 4,
                  '2023.10.05~ 2024.12.19'),
              _teamWidget("", '머신러닝의이해와실제', '머신러닝 활용 프로그램 제작 프로젝트', 2,
                  '2023.11.28~ 2024.12.08'),
              _teamWidget(
                  "", '빽스타2기', '빽다방서포터즈 팀작업', 4, '2023.07.01~ 2024.10.01'),
            ],
          ),
        ));
  }

  Widget _teamWidget(String img, String title, String description,
      int memberSize, String date) {
    return SizedBox(
      height: 53,
      child: Column(
        children: [
          Expanded(child: Row(
            children: [
              _teamImgWidget(img),
              const SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _teamTitleWidget(title),
                  _teamDescriptionWidget(description),
                  Row(
                    children: [
                      _groupInfoWidget(memberSize),
                      const SizedBox(
                        width: 31,
                      ),
                      _dateWidget(date),
                    ],
                  )
                ],
              )
            ],
          )),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget _teamImgWidget(String img) {
    // TODO : 이미지 표시하기
    return Container(
      width: 53,
      height: 50,
      decoration: ShapeDecoration(
        color: const Color(0xFFD9D9D9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _teamTitleWidget(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 11,
        fontFamily: 'SanumSquareNeo',
        fontWeight: FontWeight.w700,
        height: 0,
      ),
    );
  }

  Widget _teamDescriptionWidget(String desc) {
    return Text(
      desc,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 7,
        fontFamily: 'SanumSquareNeo',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

  Widget _groupInfoWidget(int memberSize) {
    return Row(
      children: [
        Container(
            width: 6,
            height: 8,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: Image.asset(ImagePath.groupIcon)),
        const SizedBox(
          width: 2,
        ),
        Text(
          "$memberSize",
          style: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 8,
            fontFamily: 'NanumSquare Neo OTF',
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
      ],
    );
  }

  Widget _dateWidget(String date) {
    return const Text(
      '2023.11.28~ 2024.12.08',
      style: TextStyle(
        color: Color(0xFF969696),
        fontSize: 7,
        fontFamily: 'SanumSquareNeo',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

  Widget _bottomBanner() {
    return Container(
      width: double.infinity,
      height: 69,
      decoration: ShapeDecoration(
        color: const Color(0xFFFFF1EF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              children: [
                Text(
                  '빠르고 간단하게 팀플 약속잡기!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontFamily: 'SanumSquareNeo',
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
                    fontFamily: 'SanumSquareNeo',
                    fontWeight: FontWeight.w800,
                    height: 0,
                  ),
                )
              ],
            ),
            Container(
                width: 47,
                height: 45,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: Image.asset(ImagePath.bottomBannerIcon))
          ],
        ),
      ),
    );
  }
}
