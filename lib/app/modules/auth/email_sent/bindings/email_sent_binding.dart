import 'package:get/get.dart';

import '../controllers/email_sent_controller.dart';

class EmailSentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => EmailSentController(),
    );
  }
}
