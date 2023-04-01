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
  List<TransactionDetailItemModel> detailItemsList = [];
  RxBool makeGrandTotalSameAsSubTotal = true.obs;

  Future getAllDetailItems() async {
    try {
      final response = await supabaseClient
          .from('TransactionDetail')
          .select()
          .eq('TransactionId', trxHeader.id);

      response.forEach((detail) {
        detailItemsList.add(
          TransactionDetailItemModel(
            id: detail['Id'],
            name: detail['Name'],
            qty: detail['Quantity'],
            price: detail['Price'],
            totalPrice: detail['TotalPrice'],
          ),
        );
      });

      update();
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
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
