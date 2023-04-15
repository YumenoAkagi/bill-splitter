import 'package:get/get.dart';

import '../controllers/transaction_proof_controller.dart';

class TransactionProofBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => TransactionProofController(),
    );
  }
}
