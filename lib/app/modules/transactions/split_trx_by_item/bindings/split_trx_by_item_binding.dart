import 'package:get/get.dart';

import '../controllers/split_trx_by_item_controller.dart';

class SplitTrxByItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SplitTrxByItemController(),
    );
  }
}
