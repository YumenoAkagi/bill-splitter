import 'package:bill_splitter/app/providers/transactions_provider.dart';
import 'package:bill_splitter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/transaction_detail_item_model.dart';
import '../../../../models/transaction_header_model.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/validations_helper.dart';

class AddTrxDetailsItemsController extends GetxController {
  final trxHeader = Get.arguments as TransactionHeader;
  final trxRepo = TransactionsProvider();
  List<TransactionDetailItemModel> detailItemsList = [];
  RxBool makeGrandTotalSameAsSubTotal = true.obs;

  Future getAllDetailItems() async {
    detailItemsList = await trxRepo.fetchDetailsItems(trxHeader.id);

    update();
  }

  Future<void> askAddItemMethod() async {
    final result = await showDialog<int>(
      context: Get.context as BuildContext,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Method'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Get.back(result: 1);
            },
            child: Row(
              children: const [
                Icon(
                  Entypo.camera,
                ),
                SizedBox(
                  width: 10 * GOLDEN_RATIO,
                ),
                Text('Scan Receipt'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Get.back(result: 2);
            },
            child: Row(
              children: const [
                Icon(
                  Entypo.plus_squared,
                ),
                SizedBox(
                  width: 10 * GOLDEN_RATIO,
                ),
                Text('Add item manually'),
              ],
            ),
          ),
        ],
      ),
    );

    if (result == null) return;
    if (result == 1) {
      return;
    }
    if (result == 2) {
      Get.toNamed('${Routes.ADDTRXITEM}/${Routes.ADDITEMMANUAL}');
      return;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getAllDetailItems();
  }
}
