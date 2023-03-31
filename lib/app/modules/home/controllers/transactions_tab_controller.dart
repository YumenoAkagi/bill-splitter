import '../../../utils/app_constants.dart';
import '../../../utils/validations_helper.dart';
import 'package:get/get.dart';

import '../../../models/transaction_header_model.dart';
import '../../../providers/transactions_provider.dart';

class TransactionsTabController extends GetxController {
  final TransactionsProvider _transactionsRepo = TransactionsProvider();
  List<TransactionHeader> headersList = [];

  Future getActiveTransactions() async {
    headersList = await _transactionsRepo.getActiveTransactions();
    update();
  }

  Future deleteTransaction(String id) async {
    try {
      await supabaseClient.from('TransactionHeader').delete().eq('Id', id);
      headersList.removeWhere((header) => header.id == id);

      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar('Success', 'Transaction successfully deleted');
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    getActiveTransactions();
  }
}
