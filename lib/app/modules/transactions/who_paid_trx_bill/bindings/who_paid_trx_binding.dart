import 'package:get/get.dart';

import '../controllers/who_paid_trx_bill_controller.dart';

class WhoPaidTrxBillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => WhoPaidTrxBillController(),
    );
  }
}
