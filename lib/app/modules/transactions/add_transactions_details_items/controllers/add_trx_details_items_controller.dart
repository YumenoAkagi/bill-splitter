import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/transaction_detail_item_model.dart';
import '../../../../models/transaction_header_model.dart';
import '../../../../providers/transactions_provider.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../../../home/controllers/transactions_tab_controller.dart';

class AddTrxDetailsItemsController extends GetxController {
  TransactionHeader trxHeader = Get.arguments as TransactionHeader;
  final trxRepo = TransactionsProvider();
  final grandTotalController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxList<TransactionDetailItemModel> detailItemsList =
      List<TransactionDetailItemModel>.empty(growable: true).obs;
  RxBool makeGrandTotalSameAsSubTotal = true.obs;
  RxDouble subtotal = 0.0.obs;
  bool isFetching = false;
  RxBool isLoading = false.obs;

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
    subtotal.value = detailItemsList.fold(0, (prev, e) => prev + e.totalPrice);
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

      showSuccessSnackbar('Success', 'Item successfully deleted.');
    } catch (e) {
      detailItemsList.insert(deletedIdx, deletedItem);
      showUnexpectedErrorSnackbar(e);
    } finally {
      _toggleFetchingStatus(false);
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

  Future<void> finalizeDetailItems() async {
    if (!(formKey.currentState?.validate() ?? true)) return;

    isLoading.value = true;

    // calculate grand total
    num grandTotal = 0.0;
    if (makeGrandTotalSameAsSubTotal.isTrue) {
      grandTotal = subtotal.value;
    } else {
      grandTotal = separatorFormatter.parse(grandTotalController.text);
    }

    final isFinalized =
        await trxRepo.finalizeDetailItem(trxHeader.id, grandTotal);

    if (isFinalized) {
      trxHeader.isMemberFinalized = true;
      // update list in tab and dashboard
      try {
        final transactionTabController = Get.find<TransactionsTabController>();
        await transactionTabController.getActiveTransactions();
      } catch (e) {
        // do nothing
      }

      isLoading.value = false; // update tab
      Get.offNamed(Routes.ADDTRXMEMBERS, arguments: trxHeader);
    } else {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getAllDetailItems();
  }
}
