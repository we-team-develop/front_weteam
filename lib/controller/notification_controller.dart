import 'package:front_weteam/service/api_service.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../model/weteam_notification.dart';

class NotificationController extends GetxController {
  late PagingController<int, WeteamNotification> _pagingController;
  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    _init();

    _pagingController.addPageRequestListener((pageKey) async {
      List<WeteamNotification>? newList = await _fetchPage(pageKey);
      if (newList == null) {
        _pagingController.appendPage([], currentPage);
        return;
      }

      if (newList.isEmpty) {
        _pagingController.appendLastPage([]);
        return;
      }

      _pagingController.appendPage(newList, currentPage++);
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

  Future<List<WeteamNotification>?> _fetchPage(int page) async {
    return await Get.find<ApiService>().getAlarms(page);
  }

  PagingController<int, WeteamNotification> getPagingController() {
    return _pagingController;
  }

}
