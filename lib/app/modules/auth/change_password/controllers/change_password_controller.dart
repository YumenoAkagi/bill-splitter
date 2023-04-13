import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';

class ChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxString confirmPasswordText = ''.obs;
  RxBool isLoading = false.obs;

  Future submitNewPassword() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      await supabaseClient.auth.updateUser(UserAttributes(
        password: newPasswordController.text,
      ));

      //showSuccessSnackbar('Success', 'Password successfully changed.');
      Get.offNamed(Routes.DONE_CHANGE_PASSWORD);
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    } finally {
      isLoading.value = true;
    }
  }
}
