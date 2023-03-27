import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/validations_helper.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final _supabaseClient = Get.find<SupabaseClient>();

  Future<void> sendPasswordRecoveryEmail() async {
    if (!formKey.currentState!.validate()) return;
    try {
      await _supabaseClient.auth.resetPasswordForEmail(
        emailController.text,
        redirectTo: kIsWeb ? null : 'com.binus.skripsi.bill_splitter://login',
      );
      Get.offAllNamed(Routes.RECOVERY_EMAIL_SENT);
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }
}
