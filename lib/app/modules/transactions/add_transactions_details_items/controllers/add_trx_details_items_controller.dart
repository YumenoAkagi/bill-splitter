import 'package:bill_splitter/app/providers/transactions_provider.dart';
import 'package:bill_splitter/app/routes/app_pages.dart';
import 'package:bill_splitter/app/utils/functions_helper.dart';
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
  RxList<TransactionDetailItemModel> detailItemsList =
      List<TransactionDetailItemModel>.empty(growable: true).obs;
  RxBool makeGrandTotalSameAsSubTotal = true.obs;
  RxDouble subtotal = 0.0.obs;
  bool isFetching = false;

  void _toggleFetchingStatus(bool newStat) {
    isFetching = newStat;
    update();
  }

  Future getAllDetailItems() async {
    _toggleFetchingStatus(true);
    detailItemsList.value = await trxRepo.fetchDetailsItems(trxHeader.id);
    recalculateSubtotal();
    _toggleFetchingStatus(false);
  }

  void recalculateSubtotal() {
    subtotal.value =
        detailItemsList.value.fold(0, (prev, e) => prev + e.totalPrice);
  }

  Future<void> removeItem(int id) async {
    TransactionDetailItemModel deletedItem =
        detailItemsList.firstWhere((item) => item.id == id);
    int deletedIdx = -1;
    try {
      _toggleFetchingStatus(true);
      await supabaseClient.from('TransactionDetail').delete().eq('Id', id);
      deletedIdx = detailItemsList.indexWhere((item) => item.id == id);
      detailItemsList.removeAt(deletedIdx);
      recalculateSubtotal();
      _toggleFetchingStatus(false);

      showSuccessSnackbar('Success', 'Item successfully deleted.');
    } catch (e) {
      detailItemsList.insert(deletedIdx, deletedItem);
      showUnexpectedErrorSnackbar(e);
    }
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
