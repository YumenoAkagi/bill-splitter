import 'package:get/get.dart';

import '../controllers/configs_controller.dart';

class ConfigsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ConfigsController(),
    );
  }
}
