import 'package:get/get.dart';

import '../controllers/add_trx_details_items_controller.dart';

class AddTrxDetailsItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AddTrxDetailsItemsController(),
    );
  }
}
