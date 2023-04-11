import 'package:get/get.dart';

import '../controllers/split_success_controller.dart';

class SplitSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SplitSuccessController(),
    );
  }
}
