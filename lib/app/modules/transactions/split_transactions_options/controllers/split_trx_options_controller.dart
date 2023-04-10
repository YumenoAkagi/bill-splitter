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
      final totalEquallySplitted =
          trxHeader.grandTotal / trxHeader.membersList.length;
      final totalAmountPaidByMembers = whoPaidController.membersWhoPaidBill
          .fold(0.0, (prev, trxPaid) => prev + trxPaid.paidAmount);

      bool isSucceed = true;

      for (var i = 0; i < trxHeader.membersList.length; i++) {
        final currentMember = trxHeader.membersList[i];
        for (var j = 0; i < membersWhoPaidBill.length; j++) {
          if (membersWhoPaidBill.firstWhereOrNull(
                  (trxPaid) => trxPaid.member.id == currentMember.id) ==
              null) {
            // if the member not paying the bill, then the member gets all the total amount owed splitted
            isSucceed = await _transactionRepo.addTransactionUser(
              trxHeader.id,
              currentMember.id,
              membersWhoPaidBill[j].member.id,
              membersWhoPaidBill[j].paidAmount /
                  totalAmountPaidByMembers *
                  totalEquallySplitted,
            );
          } else {
            // if the member is also paying for the bill, check if the member has debts
            final debtsOrSurplusAmount =
                membersWhoPaidBill[j].paidAmount - totalAmountPaidByMembers;
            if (debtsOrSurplusAmount < 0.0 &&
                membersWhoPaidBill[j].member.id != currentMember.id) {
              // if have debts, share equally to other members excl. this member
              isSucceed = await _transactionRepo.addTransactionUser(
                trxHeader.id,
                currentMember.id,
                membersWhoPaidBill[j].member.id,
                (membersWhoPaidBill[j].paidAmount /
                        totalAmountPaidByMembers *
                        debtsOrSurplusAmount)
                    .abs(),
              );
            }
          }

          if (!isSucceed) {
            // revert
            await _transactionRepo.deleteAllTransactionUser(trxHeader.id);
            return;
          }
        }
      }
      isLoading.value = false;
      Get.offNamed(Routes.SPLITSUCCESS);
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
  }

  Future splitByItem() async {}
}
