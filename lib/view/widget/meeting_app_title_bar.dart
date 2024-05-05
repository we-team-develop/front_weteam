import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_title_bar.dart';

class MeetingAppTitleBar extends StatelessWidget {
  final String title;
  const MeetingAppTitleBar({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTitleBar(title: ''),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumGothic',
                fontSize: 20.sp),
          )
          ,
        )
      ],
    );
  }
}
