import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/trx_member_pays_the_bill_model.dart';
import '../../../models/user_model.dart';
import '../../../modules/transactions/who_paid_trx_bill/controllers/who_paid_trx_bill_controller.dart';
import '../../../utils/functions_helper.dart';

class BsAddPaidBillMemberController extends GetxController {
  final formKey = GlobalKey<FormState>();
  UserModel? selectedMember;
  final amountPaidController = TextEditingController();
  RxList<UserModel> trxMembers = <UserModel>[].obs;
  late final double maxAmountPaid;

  void _refreshTrxMembers() {
    try {
      final whoPaidController = Get.find<WhoPaidTrxBillController>();
      for (var member in whoPaidController.trxHeader.membersList) {
        if (whoPaidController.membersWhoPaidBill
                .firstWhereOrNull((e) => e.member.id == member.id) ==
            null) {
          trxMembers.add(member);
        }
      }
      maxAmountPaid = whoPaidController.remainingAmount.value;
    } catch (e) {
      // do nothing
    }
  }

  Future addMemberToList() async {
    if (!formKey.currentState!.validate()) return;

    final amountPaid = separatorFormatter.parse(amountPaidController.text);
    try {
      final whoPaidController = Get.find<WhoPaidTrxBillController>();
      if (!whoPaidController.validateRemainingAmount(amountPaid.toDouble())) {
        await showErrorSnackbar('Amount Paid exceeded Remaining Amount');
        return;
      }
      whoPaidController.addMemberPaidBill(
        TrxMemberPaysTheBillModel(
            member: selectedMember!, paidAmount: amountPaid.toDouble()),
      );
    } catch (e) {
      // do nothing
    }
    if (Get.isBottomSheetOpen ?? false) Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    _refreshTrxMembers();
  }
}
