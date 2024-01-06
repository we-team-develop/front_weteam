import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/controller/tp_controller.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:front_weteam/view/widget/app_title_widget.dart';
import 'package:front_weteam/view/widget/team_information_widget.dart';
import 'package:get/get.dart';

class TeamPlay extends GetView<TeamPlayController> {
  const TeamPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w, top: 25.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppTitleWidget(),
          SizedBox(
            height: 22.0.h,
          ),
          Text(
            '닉네임님이 진행중이신 팀플이에요!',
            style: TextStyle(
                fontFamily: 'NanumGothic',
                fontSize: 14.0.sp,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 11.0,
          ),
          Image.asset(
            ImagePath.tpBanner,
            width: 330.w,
            height: 205.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 24.0.h,
          ),
          _teamlist(),
        ],
      ),
    );
  }

  Widget _teamlist() {
    return const Expanded(
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
    ));
  }
}
