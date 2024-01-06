import 'package:flutter/material.dart';
import 'package:front_weteam/data/image_data.dart';

class TeamInformationWidget extends StatelessWidget {
  final String img;
  final String title;
  final String description;
  final int memberSize;
  final String date;

  const TeamInformationWidget(
      {super.key,
      this.img = "",
      this.title = "",
      this.description = "",
      this.memberSize = 1,
      this.date = ""});
  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return SizedBox(
      height: 53,
      child: Column(
        children: [
          Expanded(
              child: Row(
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
                      _teamMemberCountWidget(memberSize),
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
      width: 50,
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
        fontFamily: 'NanumSquareNeo',
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
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

  Widget _teamMemberCountWidget(int memberSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
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
        Column(
          children: [
            const SizedBox(
              height: 1,
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
        )
      ],
    );
  }

  Widget _dateWidget(String date) {
    return const Text(
      '2023.11.28~ 2024.12.08',
      style: TextStyle(
        color: Color(0xFF969696),
        fontSize: 7,
        fontFamily: 'NanumSquareNeo',
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }
}
