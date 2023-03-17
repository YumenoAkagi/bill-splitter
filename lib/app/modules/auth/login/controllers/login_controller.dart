import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/validations_helper.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _supabaseClient = Get.find<SupabaseClient>();

  RxBool isLoading = false.obs;

  Future loginWithEmailPassword() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = !isLoading.value;

    final strg = Get.find<GetStorage>();

    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Get.offAllNamed(Routes.HOME);
    } on AuthException catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar('Error', e.message);
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
