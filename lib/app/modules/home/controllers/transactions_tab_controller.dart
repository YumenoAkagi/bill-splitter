import 'package:get/get.dart';

import '../../../models/transaction_header_model.dart';
import '../../../providers/transactions_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
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
    final deletedHeader = headersList.firstWhere((header) => header.id == id);
    int deletedIdx = -1;
    try {
      await supabaseClient
          .from('TransactionMember')
          .delete()
          .eq('TransactionId', id);

      await supabaseClient.from('TransactionHeader').delete().eq('Id', id);
      deletedIdx = headersList.indexWhere((header) => header.id == id);
      headersList.removeAt(deletedIdx);

      update();

      showSuccessSnackbar('Success', 'Transaction successfully deleted');
    } catch (e) {
      headersList.insert(deletedIdx, deletedHeader);
      showUnexpectedErrorSnackbar(e);
    }
  }

  void viewTrxDetail(String id) {
    final selectedHeader =
        headersList.firstWhereOrNull((head) => head.id == id);
    if (selectedHeader != null) {
      if (!selectedHeader.isItemFinalized) {
        Get.toNamed(Routes.ADDTRXITEM, arguments: selectedHeader);
        return;
      }

      if (!selectedHeader.isMemberFinalized) {
        // Get.toNamed(Routes.ADDTRXITEM, arguments: selectedHeader);
        return;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    getActiveTransactions();
  }
}
