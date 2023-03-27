import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/validations_helper.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future<void> sendPasswordRecoveryEmail() async {
    if (!formKey.currentState!.validate()) return;
    try {
      await supabaseClient.auth.resetPasswordForEmail(
        emailController.text,
        redirectTo:
            kIsWeb ? null : 'com.binus.skripsi.billsplitter://url-callback/',
      );
      Get.offAllNamed(Routes.RECOVERY_EMAIL_SENT);
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
  }
}
