import 'package:get/get.dart';

import '../../../../models/transaction_header_model.dart';
import '../../../../providers/transactions_provider.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/functions_helper.dart';
import '../../../home/controllers/transactions_tab_controller.dart';
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
      final allSurplusMember = membersWhoPaidBill
          .where((e) => (e.paidAmount - totalEquallySplitted) > 0.0)
          .toList(); // member who paid and will not have debts
      final totalSurplus = membersWhoPaidBill
          .where((mem) => (mem.paidAmount - totalEquallySplitted) > 0.0)
          .fold(0.0, (prev, e) => prev + (e.paidAmount - totalEquallySplitted));

      bool isSucceed = true;

      for (var i = 0; i < trxHeader.membersList.length; i++) {
        final currentMember = trxHeader.membersList[i];
        final isMemberPaidForBill = membersWhoPaidBill
            .firstWhereOrNull((mem) => mem.member.id == currentMember.id);

        if (isMemberPaidForBill != null) {
          // if minus then split
          final debtsOrSurplusAmount =
              isMemberPaidForBill.paidAmount - totalEquallySplitted;
          if (debtsOrSurplusAmount < 0.0) {
            // the member paid splitted for all surplus
            for (var j = 0; j < allSurplusMember.length; j++) {
              isSucceed = await _transactionRepo.addTransactionUser(
                trxHeader.id,
                currentMember.id,
                allSurplusMember[j].member.id,
                ((allSurplusMember[j].paidAmount - totalEquallySplitted) /
                        totalSurplus *
                        debtsOrSurplusAmount.abs())
                    .ceilToDouble(),
              );
            }
          }
        } else {
          // if not paying the bill, member split to all surplus from eq split
          for (var j = 0; j < allSurplusMember.length; j++) {
            isSucceed = await _transactionRepo.addTransactionUser(
              trxHeader.id,
              currentMember.id,
              allSurplusMember[j].member.id,
              ((allSurplusMember[j].paidAmount - totalEquallySplitted) /
                  totalSurplus *
                  totalEquallySplitted.ceilToDouble()),
            );
          }
        }

        if (!isSucceed) {
          // revert
          await _transactionRepo.deleteAllTransactionUser(trxHeader.id);
          return;
        }
      }
      isLoading.value = false;
      try {
        final transactionTabController = Get.find<TransactionsTabController>();
        await transactionTabController.getActiveTransactions();
      } catch (e) {
        // do nothing
      }
      Get.offNamed(Routes.SPLITSUCCESS);
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
  }

  Future splitByItem() async {
    Get.toNamed('${Routes.TRXSPLITOPTIONS}/${Routes.TRXASSIGNMEMBERTOITEM}',
        arguments: trxHeader);
  }
}
