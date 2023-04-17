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
  final discController = TextEditingController();

  int itemId = -1;
  RxBool isLoading = false.obs;
  RxDouble maxDiscount = 0.0.obs;

  void recalculateMaxDiscount() {
    final qtyRaw = separatorFormatter
        .parse(qtyController.text != '' ? qtyController.text : '0');
    final priceRaw = separatorFormatter
        .parse(itemPriceController.text != '' ? itemPriceController.text : '0');
    final totalPriceRaw = qtyRaw * priceRaw;
    maxDiscount.value = totalPriceRaw.toDouble();
    if (discController.text != '' &&
        (separatorFormatter.parse(discController.text) > totalPriceRaw)) {
      discController.text = separatorFormatter.format(totalPriceRaw);
    }
  }

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
      discController.text = separatorFormatter
          .format(trxDetailItemController.selectedItem!.discount);
      recalculateMaxDiscount();
    } catch (e) {}
  }

  Future editItem() async {
    _toggleLoadingStatus(true);
    final qtyRaw = separatorFormatter.parse(qtyController.text);
    final priceRaw = separatorFormatter.parse(itemPriceController.text);
    num discountRaw = 0;
    if (discController.text != '') {
      discountRaw = separatorFormatter.parse(discController.text);
    }
    final num totalPriceRaw = (qtyRaw * priceRaw) - discountRaw;
    final isSucceed = await _transactionRepo.editDetailsItem(
      itemId,
      itemNameController.text,
      priceRaw.toDouble(),
      qtyRaw.toDouble(),
      totalPriceRaw.toDouble(),
      discountRaw.toDouble(),
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
