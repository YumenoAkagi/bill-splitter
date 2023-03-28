import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/validations_helper.dart';

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();

  RxString confirmPasswordText = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    newPasswordController.dispose();
    super.onClose();
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      await supabaseClient.auth.updateUser(UserAttributes(
        password: newPasswordController.text,
      ));

      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar('Success',
          'Password successfully changed. Try login with your new password.');
      Get.offNamed(Routes.LOGIN);
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    } finally {
      isLoading.value = true;
    }
  }
}