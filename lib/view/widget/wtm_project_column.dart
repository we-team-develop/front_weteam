import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/wtm_project.dart';
import 'wtm_project_widget.dart';

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
      physics: const AlwaysScrollableScrollPhysics(), // 항상 스크롤 가능하도록 설정
      itemBuilder: (_, i) =>
          Padding(padding: padding, child: WTMProjectWidget(wtmList[i])),
    );
  }
}
