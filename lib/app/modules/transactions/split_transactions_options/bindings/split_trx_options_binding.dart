import 'package:get/get.dart';

import '../controllers/split_trx_options_controller.dart';

class SplitTrxOptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SplitTrxOptionsController(),
    );
  }
}
