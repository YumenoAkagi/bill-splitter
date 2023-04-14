import 'package:get/get.dart';

import '../controllers/add_item_ocr_controller.dart';

class AddItemOCRBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AddItemOCRController(),
    );
  }
}
