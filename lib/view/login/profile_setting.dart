import 'package:flutter/material.dart';
import 'package:front_weteam/app.dart';
import 'package:front_weteam/data/image_data.dart';
import 'package:get/get.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WE TEAM',
                  style: TextStyle(
                    fontFamily: 'SBaggroB',
                    color: Color(0xFFE2583E),
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '팀원들에게 보여줄 프로필 사진을 선택해 주세요!',
                  style: TextStyle(
                    fontFamily: 'NanumGothicBold',
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 50.0),
                _profileImage(),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.08,
                left: 15.0,
                right: 15.0),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => const App());
                },
                child: Image.asset(ImagePath.startweteambutton)),
          ),
        ),
      ],
    );
  }

  Widget _profileImage() {
    double circleSize = 80.0;

    List<String> imagePaths = [
      ImagePath.profile1,
      ImagePath.profile2,
      ImagePath.profile3,
      ImagePath.profile4,
      ImagePath.profile5,
      ImagePath.profile6,
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      children: List.generate(6, (index) {
        return Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              image: DecorationImage(
                image: AssetImage(imagePaths[index]),
                fit: BoxFit.cover,
              )),
        );
      }),
    );
  }
}
