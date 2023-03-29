import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../utils/validations_helper.dart';

class AddTransactionBsController extends GetxController {
  final nameController = TextEditingController();
  DateTime? selectedDate = DateTime.now();

  RxBool isLoading = false.obs;

  final _supabaseClient = Get.find<SupabaseClient>();
  void setDate(List<DateTime?> dates) {
    selectedDate = dates.first;
  }

  Future addTransaction() async {
    try {
      await _supabaseClient.from('TransactionHeader').insert({
        'Name': nameController.text,
        'Date': selectedDate,
      });
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }
}
