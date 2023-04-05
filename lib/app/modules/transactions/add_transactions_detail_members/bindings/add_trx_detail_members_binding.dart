import 'package:bill_splitter/app/modules/transactions/add_transactions_detail_members/controllers/add_trx_detail_members_controller.dart';
import 'package:get/get.dart';

class AddTrxDetailMembersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AddTrxDetailMembersController(),
    );
  }
}
