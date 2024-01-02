import 'package:flutter/material.dart';
import 'package:front_weteam/data/image_data.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    var padding = MediaQuery.of(context).size.height * 0.01; // 버튼 사이 패딩
    var horizontalPadding =
        MediaQuery.of(context).size.width * 0.06; // 버튼 양옆 패딩
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(ImagePath.appicon),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Image.asset(ImagePath.googlelogin),
              ),
              SizedBox(height: padding),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Image.asset(ImagePath.kakaologin),
              ),
              SizedBox(height: padding),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Image.asset(ImagePath.naverlogin),
              ),
              SizedBox(height: padding),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Image.asset(ImagePath.applelogin),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            ],
          ),
        ],
      ),
    );
  }
}
