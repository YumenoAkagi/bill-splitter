import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../modules/transactions/add_transactions_details_items/controllers/add_trx_details_items_controller.dart';
import '../../../providers/transactions_provider.dart';
import '../../../utils/functions_helper.dart';

class BsEditItemController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final itemNameController = TextEditingController();
  final qtyController = TextEditingController();
  final itemPriceController = TextEditingController();
  final _transactionRepo = TransactionsProvider();

  int itemId = -1;
  RxBool isLoading = false.obs;

  void _toggleLoadingStatus(bool newStat) {
    isLoading.value = newStat;
    // update();
  }

  void initItem() {
    try {
      final trxDetailItemController = Get.find<AddTrxDetailsItemsController>();
      itemId = trxDetailItemController.selectedItem!.id;
      itemNameController.text = trxDetailItemController.selectedItem!.name;
      qtyController.text =
          trxDetailItemController.selectedItem!.qty.toStringAsFixed(0);
      itemPriceController.text = separatorFormatter
          .format(trxDetailItemController.selectedItem!.price);
    } catch (e) {}
  }

  Future editItem() async {
    _toggleLoadingStatus(true);
    final qtyRaw = separatorFormatter.parse(qtyController.text);
    final priceRaw = separatorFormatter.parse(itemPriceController.text);
    final num totalPriceRaw = qtyRaw * priceRaw;
    final isSucceed = await _transactionRepo.editDetailsItem(
      itemId,
      itemNameController.text,
      priceRaw.toDouble(),
      qtyRaw.toDouble(),
      totalPriceRaw.toDouble(),
    );

    if (isSucceed) {
      try {
        final trxDetailItemController =
            Get.find<AddTrxDetailsItemsController>();
        await trxDetailItemController.getAllDetailItems();
      } catch (e) {}
      Get.back();
    }

    _toggleLoadingStatus(false);
  }

  @override
  void onReady() {
    super.onReady();
    initItem();
  }
}
