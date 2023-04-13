import 'package:get/get.dart';

import '../../../../models/transaction_header_model.dart';
import '../../../../models/trx_member_pays_the_bill_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/functions_helper.dart';

class WhoPaidTrxBillController extends GetxController {
  TransactionHeaderModel trxHeader = Get.arguments as TransactionHeaderModel;
  RxDouble remainingAmount = 0.0.obs;
  RxList<TrxMemberPaysTheBillModel> membersWhoPaidBill =
      <TrxMemberPaysTheBillModel>[].obs;

  void recalculateRemainingAmount() {
    remainingAmount.value = trxHeader.grandTotal.toDouble();
    final totalAmountPaid =
        membersWhoPaidBill.fold(0.0, (prev, mem) => prev + mem.paidAmount);
    remainingAmount.value -= totalAmountPaid;

    update();
  }

  void addMemberPaidBill(TrxMemberPaysTheBillModel memberPaysTheBill) {
    membersWhoPaidBill.add(memberPaysTheBill);
    recalculateRemainingAmount();
  }

  void removeMemberPaidBill(TrxMemberPaysTheBillModel memberPaysTheBill) {
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
