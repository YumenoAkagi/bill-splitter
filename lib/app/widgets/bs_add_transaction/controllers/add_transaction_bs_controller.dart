import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/validations_helper.dart';

class AddTransactionBsController extends GetxController {
  final nameController = TextEditingController();
  final selectDateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  DateTime? selectedDate = DateTime.now();
  RxBool isLoading = false.obs;

  void setDate(DateTime? value) {
    selectedDate = value;
  }

  @override
  void onInit() {
    super.onInit();
    setDate(DateTime.now());
    selectDateController.text =
        DateFormat('dd MMM yyyy').format(selectedDate ?? DateTime.now());
  }

  Future addTransaction() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final response = await supabaseClient.from('TransactionHeader').insert({
        'Name': nameController.text,
        'Date': selectedDate!.toIso8601String(),
      }).select();

      // add owner as member
      await supabaseClient.from('TransactionMember').insert({
        'UserId': supabaseClient.auth.currentUser?.id,
        'TransactionId': response[0]['Id'],
      });

      // close bottomsheet
      if (Get.isBottomSheetOpen != null && Get.isBottomSheetOpen!) {
        Get.back();
      }

      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar('Success', 'New Transaction successfully added.');
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
