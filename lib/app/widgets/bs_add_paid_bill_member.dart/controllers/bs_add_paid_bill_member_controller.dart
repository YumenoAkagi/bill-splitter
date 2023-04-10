import 'package:bill_splitter/app/models/trx_member_pays_the_bill.dart';
import 'package:bill_splitter/app/utils/functions_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../modules/transactions/who_paid_trx_bill/controllers/who_paid_trx_bill_controller.dart';

class BsAddPaidBillMemberController extends GetxController {
  final formKey = GlobalKey<FormState>();
  UserModel? selectedMember;
  final amountPaidController = TextEditingController();
  RxList<UserModel> trxMembers = <UserModel>[].obs;

  void _refreshTrxMembers() {
    try {
      final whoPaidController = Get.find<WhoPaidTrxBillController>();
      trxMembers.value = whoPaidController.trxHeader.membersList;
    } catch (e) {
      // do nothing
    }
  }

  Future addMemberToList() async {
    if (!formKey.currentState!.validate()) return;

    final amountPaid = separatorFormatter.parse(amountPaidController.text);
    try {
      final whoPaidController = Get.find<WhoPaidTrxBillController>();
      if(!whoPaidController.validateRemainingAmount(amountPaid.toDouble())) {
        await showErrorSnackbar('Amount Paid exceeded Remaining Amount');
        return;
      }
      whoPaidController.addMemberPaidBill(
        TrxMemberPaysTheBill(
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