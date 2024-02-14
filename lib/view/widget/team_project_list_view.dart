import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/team_project.dart';
import 'team_project_widget.dart';
class TeamProjectListView extends StatelessWidget {
  final ScrollController? scrollController;
  final List<TeamProject> tpList;

  const TeamProjectListView(this.tpList, {this.scrollController, super.key});

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = EdgeInsets.only(bottom: 12.h);
    return ListView.builder(
      controller: scrollController,
      itemCount: tpList.length,
      itemBuilder: (_, i) => Padding(padding: padding, child: TeamProjectWidget(tpList[i])),
    );
  }
}
