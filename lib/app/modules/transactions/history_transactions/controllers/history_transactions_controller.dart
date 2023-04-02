import 'package:get/get.dart';

import '../../../../models/transaction_header_model.dart';
import '../../../../providers/transactions_provider.dart';
import '../../../../utils/functions_helper.dart';

class HistoryTransactionsController extends GetxController {
  final transactionsRepo = TransactionsProvider();
  List<TransactionHeader> historyTransactionsList = [];

  Future getAllHistoryTransactions() async {
    try {
      update();
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
  }
}
