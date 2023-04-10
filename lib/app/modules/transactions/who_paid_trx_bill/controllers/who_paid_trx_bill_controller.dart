import 'package:get/get.dart';

import '../../../../models/transaction_header_model.dart';
import '../../../../models/trx_member_pays_the_bill.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/functions_helper.dart';

class WhoPaidTrxBillController extends GetxController {
  TransactionHeader trxHeader = Get.arguments as TransactionHeader;
  RxDouble remainingAmount = 0.0.obs;
  RxList<TrxMemberPaysTheBill> membersWhoPaidBill =
      <TrxMemberPaysTheBill>[].obs;

  void recalculateRemainingAmount() {
    remainingAmount.value = trxHeader.grandTotal.toDouble();
    final totalAmountPaid =
        membersWhoPaidBill.fold(0.0, (prev, mem) => prev + mem.paidAmount);
    remainingAmount.value -= totalAmountPaid;

    update();
  }

  void addMemberPaidBill(TrxMemberPaysTheBill memberPaysTheBill) {
    membersWhoPaidBill.add(memberPaysTheBill);
    recalculateRemainingAmount();
  }

  void removeMemberPaidBill(TrxMemberPaysTheBill memberPaysTheBill) {
    membersWhoPaidBill.remove(memberPaysTheBill);
    recalculateRemainingAmount();
  }

  void checkRemainingAmountAndNavigate() {
    if (remainingAmount.value > 0.0) {
      showErrorSnackbar('You have not reach the total payment needed yet.');
      return;
    }
    Get.toNamed(Routes.TRXSPLITOPTIONS, arguments: trxHeader);
  }

  bool validateRemainingAmount(double amountPaid) {
    if (amountPaid > remainingAmount.value) return false;
    return true;
  }

  @override
  void onReady() {
    super.onReady();
    recalculateRemainingAmount();
  }
}
