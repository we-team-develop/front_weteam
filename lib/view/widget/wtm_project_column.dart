import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_weteam/model/wtm_project.dart';
import 'package:front_weteam/view/widget/wtm_project_widget.dart';

class WTMProjectListView extends StatelessWidget {
  final ScrollController? scrollController;
  final List<WTMProject> wtmList;

  const WTMProjectListView(this.wtmList, {super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = EdgeInsets.only(bottom: 12.h);
    return ListView.builder(
      controller: scrollController,
      itemCount: wtmList.length,
      itemBuilder: (_, i) => WTMProjectWidget(wtmList[i]),
    );
  }
}
