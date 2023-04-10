import 'package:bill_splitter/app/modules/transactions/split_success/controllers/split_success_controller.dart';
import 'package:get/get.dart';

class SplitSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SplitSuccessController(),
    );
  }
}
