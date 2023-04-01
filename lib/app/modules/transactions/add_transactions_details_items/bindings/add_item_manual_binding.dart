import 'package:bill_splitter/app/modules/transactions/add_transactions_details_items/controllers/add_item_manual_controller.dart';
import 'package:get/get.dart';

class AddItemManualBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AddItemManualController(),
    );
  }
}
