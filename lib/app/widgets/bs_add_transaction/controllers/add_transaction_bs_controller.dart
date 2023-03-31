import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  Future addTransaction() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      await supabaseClient.from('TransactionHeader').insert({
        'Name': nameController.text,
        'Date': selectedDate!.toIso8601String(),
        'CreatedById': supabaseClient.auth.currentUser?.id,
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
