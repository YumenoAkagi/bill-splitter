import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../models/transaction_detail_item_model.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import 'add_trx_details_items_controller.dart';

class AddItemManualController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final addTrxController = Get.find<AddTrxDetailsItemsController>();
  final nameController = TextEditingController();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  RxBool isLoading = false.obs;
  RxDouble maxDiscount = 0.0.obs;

  void recalculateMaxDiscount() {
    final qtyRaw = separatorFormatter
        .parse(qtyController.text != '' ? qtyController.text : '0');
    final priceRaw = separatorFormatter
        .parse(priceController.text != '' ? priceController.text : '0');
    final totalPriceRaw = qtyRaw * priceRaw;
    maxDiscount.value = totalPriceRaw.toDouble();
    if (discountController.text != '' &&
        (separatorFormatter.parse(discountController.text) > totalPriceRaw)) {
      discountController.text = separatorFormatter.format(totalPriceRaw);
    }
  }

  Future addNewItem() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final qtyRaw = separatorFormatter.parse(qtyController.text);
      final priceRaw = separatorFormatter.parse(priceController.text);
      num discountRaw = 0;
      if (discountController.text != '') {
        discountRaw = separatorFormatter.parse(discountController.text);
      }
      final num totalPriceRaw = (qtyRaw * priceRaw) - discountRaw;
      final response = await supabaseClient.from('TransactionDetail').insert({
        'TransactionId': addTrxController.trxHeader.id,
        'Name': nameController.text,
        'Quantity': qtyRaw,
        'Price': priceRaw,
        'Discount': discountRaw,
        'TotalPrice': totalPriceRaw,
      }).select();

      addTrxController.detailItemsList.add(
        TransactionDetailItemModel(
          id: response[0]['Id'],
          transactionId: response[0]['TransactionId'],
          name: response[0]['Name'],
          qty: response[0]['Quantity'],
          price: response[0]['Price'],
          totalPrice: response[0]['TotalPrice'],
          discount: response[0]['Discount'],
        ),
      );
      addTrxController.recalculateSubtotal();
      addTrxController.update();
      Get.back();
      await showSuccessSnackbar('Success', 'Item successfully added!');
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    } finally {
      isLoading.value = false;
    }
  }
}
