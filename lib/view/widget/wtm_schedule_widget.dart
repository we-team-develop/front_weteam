import 'package:flutter/material.dart';
import '../../model/wtm_project.dart';
import '../../controller/wtm_schedule_controller.dart';
import 'package:get/get.dart';

class WTMSchedule extends GetView<WTMScheduleController> {
  final WTMProject wtm;

  const WTMSchedule(this.wtm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _date(),
            _day(wtm),
          ],
        ),
      ],
    );
  }

  Widget _date() {
    return const Column();
  }

  Widget _day(WTMProject wtm) {
    final int daysCount = wtm.endedAt.difference(wtm.startedAt).inDays;
    final List<Widget> dayWidgets = List.generate(daysCount + 1, (index) {
      DateTime day = DateTime(
          wtm.startedAt.year, wtm.startedAt.month, wtm.startedAt.day + index);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          '${day.day}',
          style: const TextStyle(fontSize: 20),
        ),
      );
    });

    return Wrap(
      direction: Axis.horizontal, // 수평 방향으로 아이템들을 배치합니다.
      children: dayWidgets,
    );
  }
}
