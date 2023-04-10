import 'package:get/get.dart';

import '../../../../models/transaction_header_model.dart';
import '../../../../providers/transactions_provider.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/functions_helper.dart';
import '../../who_paid_trx_bill/controllers/who_paid_trx_bill_controller.dart';

class SplitTrxOptionsController extends GetxController {
  TransactionHeader trxHeader = Get.arguments as TransactionHeader;
  final _transactionRepo = TransactionsProvider();
  RxBool isLoading = false.obs;

  Future splitEqually() async {
    isLoading.value = true;
    try {
      final whoPaidController = Get.find<WhoPaidTrxBillController>();
      final membersWhoPaidBill = whoPaidController.membersWhoPaidBill;
      for (var i = 0; i < membersWhoPaidBill.length; i++) {
        for (var j = 0; j < trxHeader.membersList.length; j++) {
          // add to db
          final amountOwed =
              membersWhoPaidBill[i].paidAmount / trxHeader.membersList.length;
          final isInserted = await _transactionRepo.addTransactionUser(
            trxHeader.id,
            trxHeader.membersList[j].id,
            membersWhoPaidBill[i].member.id,
            amountOwed.ceilToDouble(),
          );

          if (!isInserted) {
            // revert all inserted trx
            await _transactionRepo.deleteAllTransactionUser(trxHeader.id);
            // showErrorSnackbar(
            //     "Error occurred when trying to split the bill. Please try again");
            return;
          }

          isLoading.value = false;
          Get.offNamed(Routes.SPLITSUCCESS);
        }
      }
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
  }

  Future splitByItem() async {}
}
