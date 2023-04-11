import 'package:get/get.dart';

import '../../../models/transaction_header_model.dart';
import '../../../providers/transactions_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/functions_helper.dart';

class TransactionsTabController extends GetxController {
  final TransactionsProvider _transactionsRepo = TransactionsProvider();
  List<TransactionHeader> headersList = [];

  bool isFetching = false;

  void _toggleFetchingStatus(bool newStat) {
    isFetching = newStat;
    update();
  }

  Future getActiveTransactions() async {
    _toggleFetchingStatus(true);
    headersList = await _transactionsRepo.getTransactionHeaders(false);
    _toggleFetchingStatus(false);
  }

  Future deleteTransaction(String id) async {
    final selectedTrx = await _transactionsRepo.getTransactionHeader(id);

    if (selectedTrx == null) {
      return;
    }

    if (selectedTrx.isDeletable == false) {
      showErrorSnackbar(
          'Delete failed. Reason: This transaction has been processed');
      return;
    }

    final deletedHeader = headersList.firstWhere((header) => header.id == id);
    final deletedIdx = headersList.indexOf(deletedHeader);

    final isDeleted = await _transactionsRepo.deleteTransaction(id);
    if (isDeleted) {
      headersList.removeAt(deletedIdx);
    }
    update();
  }

  void viewTrxDetail(String id) async {
    final selectedHeader =
        headersList.firstWhereOrNull((head) => head.id == id);
    if (selectedHeader != null) {
      if (!selectedHeader.isItemFinalized) {
        Get.toNamed(Routes.ADDTRXITEM, arguments: selectedHeader);
        return;
      }

      if (!selectedHeader.isMemberFinalized) {
        Get.toNamed(Routes.ADDTRXMEMBERS, arguments: selectedHeader);
        return;
      }

      if (!(await _transactionsRepo.isSplitted(selectedHeader.id))) {
        Get.toNamed(Routes.TRXMEMBERWHOPAID, arguments: selectedHeader);
        return;
      }

      Get.toNamed(Routes.TRXDETAIL, arguments: selectedHeader);
    }
  }

  @override
  void onReady() {
    super.onReady();
    getActiveTransactions();
  }
}
