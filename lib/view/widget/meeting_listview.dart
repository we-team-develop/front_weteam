import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/meeting.dart';
import 'meeting_widget.dart';

class MeetingListView extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Meeting> meetingList;

  const MeetingListView(this.meetingList, {super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = EdgeInsets.only(bottom: 12.h);
    return ListView.builder(
      controller: scrollController,
      itemCount: meetingList.length,
      physics: const AlwaysScrollableScrollPhysics(), // 항상 스크롤 가능하도록 설정
      itemBuilder: (_, i) =>
          Padding(padding: padding, child: MeetingWidget(meetingList[i])),
    );
  }
}
