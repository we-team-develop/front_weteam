import 'dart:developer';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../model/weteam_alarm.dart';
import '../service/api_service.dart';

class AlarmController extends GetxController {
  late PagingController<int, WeteamAlarm> _pagingController;
  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    _init();

    _pagingController.addPageRequestListener((pageKey) async {
      List<WeteamAlarm>? newList = await _fetchPage(pageKey);
      try {
        if (newList == null) {
          _pagingController.appendPage([], currentPage);
          return;
        }

        if (newList.isEmpty) {
          _pagingController.appendLastPage([]);
          return;
        }

        _pagingController.appendPage(newList, ++currentPage);
      } catch (e) {
        log("$e");
      }
    });
  }

  @override
  void onClose() {
    _pagingController.dispose();

    super.onClose();
  }

  void _init() {
    _pagingController = PagingController(firstPageKey: 0);
    currentPage = 0;
  }

  Future<List<WeteamAlarm>?> _fetchPage(int page) async {
    return await Get.find<ApiService>().getAlarms(page);
  }

  PagingController<int, WeteamAlarm> getPagingController() {
    return _pagingController;
  }
}
