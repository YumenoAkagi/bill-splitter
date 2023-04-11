import 'package:get/get.dart';

import '../controllers/add_trx_detail_members_controller.dart';

class AddTrxDetailMembersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AddTrxDetailMembersController(),
    );
  }
}
