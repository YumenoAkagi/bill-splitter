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

  RxBool isLoading = false.obs;

  Future addNewItem() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final qtyRaw = qtyController.text;
      final priceRaw = priceController.text;
      final num totalPriceRaw =
          double.parse(qtyController.text) * double.parse(priceController.text);
      final response = await supabaseClient.from('TransactionDetail').insert({
        'TransactionId': addTrxController.trxHeader.id,
        'Name': nameController.text,
        'Quantity': qtyRaw,
        'Price': priceRaw,
        'TotalPrice': totalPriceRaw
      }).select();

      addTrxController.detailItemsList.value.add(
        TransactionDetailItemModel(
          id: response[0]['Id'],
          transactionId: response[0]['TransactionId'],
          name: response[0]['Name'],
          qty: response[0]['Quantity'],
          price: response[0]['Price'],
          totalPrice: response[0]['TotalPrice'],
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
