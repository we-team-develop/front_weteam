import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/model/team_project.dart';
import 'package:front_weteam/model/weteam_user.dart';
import 'package:front_weteam/view/widget/team_project_widget.dart';
import 'package:get/get.dart';

import '../../controller/team_project_detail_page_controller.dart';

class TeamProjectDetailPage extends GetView<TeamProjectDetailPageController> {
  final TeamProject tp;

  const TeamProjectDetailPage(this.tp, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Center(
                  child: Text(
                    '팀플방',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.w600,
                    ),
                  )
              ),

              SizedBox(height: 15.h),
              const _CustomDivider(),
              TeamProjectWidget(tp),
              const _CustomDivider(),
            ],
          ),
        ),
      ),
    );
  }

}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      color: const Color(0xFFEBE8E8),
    );
  }
}

class _UserContainer extends StatelessWidget {
  final WeteamUser user;
  const _UserContainer(this.user);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: 48.49.w,
              height: 48.49.h,
              decoration: const ShapeDecoration(
                color: Color(0xFFD9D9D9),
                shape: OvalBorder(),
              ),
            ),
            SizedBox(height: 7.h),
            Text(
              "${user.username}",
              style: TextStyle(
                color: const Color(0xFF333333),
                fontSize: 10.sp,
                fontFamily: 'NanumSquareNeo',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              '디자인팀장',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF676767),
                fontSize: 9.sp,
                fontFamily: 'NanumSquareNeo',
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        )
      ],
    );
  }
  
}

class _UserListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserListViewState();
  }
}

class _UserListViewState extends State<_UserListView> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        
      ],
    );
  }
}

