import 'package:bill_splitter/app/providers/transactions_provider.dart';
import 'package:get/get.dart';

import '../../../../models/transaction_header_model.dart';
import '../../../../utils/validations_helper.dart';

class HistoryTransactionsController extends GetxController {
  final transactionsRepo = TransactionsProvider();
  List<TransactionHeader> historyTransactionsList = [];

  Future getAllHistoryTransactions() async {
    try {
      update();
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }
}
