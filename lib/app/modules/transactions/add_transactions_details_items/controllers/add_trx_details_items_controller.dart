import 'package:bill_splitter/app/models/transaction_header_model.dart';
import 'package:get/get.dart';

import '../../../../models/transaction_detail_item_model.dart';

class AddTrxDetailsItemsController extends GetxController {
  List<TransactionDetailItemModel> detailItemsList = [];
  final trxHeader = Get.arguments as TransactionHeader;

  Future getAllDetailItems() async {}
}
