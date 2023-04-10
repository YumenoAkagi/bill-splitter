import 'package:get/get.dart';

import '../../../../models/transaction_header_model.dart';

class SplitTrxOptionsController extends GetxController {
  TransactionHeader trxHeader = Get.arguments as TransactionHeader;

  Future splitEqually() async {}

  Future splitByItem() async {}
}
