import 'package:bill_splitter/app/modules/transactions/who_paid_trx_bill/controllers/who_paid_trx_bill_controller.dart';
import 'package:get/get.dart';

class WhoPaidTrxBillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => WhoPaidTrxBillController(),
    );
  }
}
