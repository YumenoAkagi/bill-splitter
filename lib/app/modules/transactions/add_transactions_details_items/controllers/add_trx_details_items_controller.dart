import 'package:get/get.dart';

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

  @override
  void onInit() {
    super.onInit();
    getAllDetailItems();
  }
}
