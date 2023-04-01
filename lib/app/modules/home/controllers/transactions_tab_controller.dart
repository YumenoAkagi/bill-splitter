import 'package:get/get.dart';

import '../../../models/transaction_header_model.dart';
import '../../../providers/transactions_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/validations_helper.dart';

class TransactionsTabController extends GetxController {
  final TransactionsProvider _transactionsRepo = TransactionsProvider();
  List<TransactionHeader> headersList = [];

  Future getActiveTransactions() async {
    headersList = await _transactionsRepo.getActiveTransactions();
    update();
  }

  Future deleteTransaction(String id) async {
    try {
      await supabaseClient
          .from('TransactionMember')
          .delete()
          .eq('TransactionId', id);

      await supabaseClient.from('TransactionHeader').delete().eq('Id', id);
      headersList.removeWhere((header) => header.id == id);

      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar('Success', 'Transaction successfully deleted');
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
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
  void onInit() {
    super.onInit();
    getActiveTransactions();
  }
}
