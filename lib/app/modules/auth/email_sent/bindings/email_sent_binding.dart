import 'package:bill_splitter/app/modules/auth/email_sent/controllers/email_sent_controller.dart';
import 'package:get/get.dart';

class EmailSentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => EmailSentController(),
    );
  }
}
