import 'package:get/get.dart';

import '../../../../models/transaction_header_model.dart';
import '../../../../providers/transactions_provider.dart';
import '../../../../utils/functions_helper.dart';

class HistoryTransactionsController extends GetxController {
  final transactionsRepo = TransactionsProvider();
  List<TransactionHeader> historyTransactionsList = [];

  bool isFetching = false;

  void _toggleFetchingStatus(bool newStat) {
    isFetching = newStat;
    update();
  }

  Future getAllHistoryTransactions() async {
    try {
      _toggleFetchingStatus(true);
      historyTransactionsList =
          await transactionsRepo.getTransactionHeaders(true);
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    } finally {
      _toggleFetchingStatus(false);
    }
  }
}
