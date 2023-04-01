import 'package:bill_splitter/app/modules/transactions/history_transactions/controllers/history_transactions_controller.dart';
import 'package:get/get.dart';

class HistoryTransactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HistoryTransactionsController(),
    );
  }
}
