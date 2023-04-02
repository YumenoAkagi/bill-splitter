import 'package:get/get.dart';

import '../controllers/add_item_manual_controller.dart';

class AddItemManualBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AddItemManualController(),
    );
  }
}
