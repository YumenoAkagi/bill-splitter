import 'package:get/get.dart';

import '../controllers/add_transaction_bs_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AddTransactionBsController(),
    );
  }
}
