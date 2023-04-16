import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../modules/transactions/who_paid_trx_bill/controllers/who_paid_trx_bill_controller.dart';
import '../../../utils/functions_helper.dart';

class BsEditPaidBillMemberController extends GetxController {
  final formKey = GlobalKey<FormState>();
  String? userId;
  final amountPaidController = TextEditingController();
  final whoPaidController = Get.find<WhoPaidTrxBillController>();
  RxDouble maxAmountPaid = 0.0.obs;

  RxBool isLoading = false.obs;

  void _initPayer() {
    userId = whoPaidController.selectedPayer!.member.id;
    amountPaidController.text =
        separatorFormatter.format(whoPaidController.selectedPayer!.paidAmount);
    maxAmountPaid.value = whoPaidController.remainingAmount.value +
        whoPaidController.selectedPayer!.paidAmount;
  }

  void editPayAmount() {
    isLoading.value = true;
    whoPaidController.editMemberPaidBill(
        separatorFormatter.parse(amountPaidController.text).toDouble(),
        userId!);
    isLoading.value = false;
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    _initPayer();
  }
}
