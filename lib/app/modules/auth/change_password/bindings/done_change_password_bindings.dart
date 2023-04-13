import 'package:get/get.dart';

import '../controllers/done_change_password_controller.dart';

class DoneChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => DoneChangePassController(),
    );
  }
}
