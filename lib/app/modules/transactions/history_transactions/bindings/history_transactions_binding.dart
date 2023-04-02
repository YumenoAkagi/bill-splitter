import 'package:get/get.dart';

import '../controllers/history_transactions_controller.dart';

class HistoryTransactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HistoryTransactionsController(),
    );
  }
}
