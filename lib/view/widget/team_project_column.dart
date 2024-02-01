import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../model/team_project.dart';
import 'team_project_widget.dart';

class TeamProjectColumn extends StatefulWidget {
  final List<TeamProject> tpList;

  const TeamProjectColumn(this.tpList, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _TeamProjectColumnState();
  }
}

class _TeamProjectColumnState extends State<TeamProjectColumn> {
  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Column( // ListView.builder 쓰면 오류나요...
      children: _buildTeamProjectWidgetList(),
    );
  }

  List<Widget> _buildTeamProjectWidgetList() {
    List<Widget> ret = [];
    Widget gap = SizedBox(height: 12.h);

    for (int i = 0; i < widget.tpList.length; i++) {
      ret.add(TeamProjectWidget(widget.tpList[i]));
      ret.add(gap);
    }

    return ret;
  }
}
