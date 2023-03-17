import 'package:bill_splitter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../utils/validations_helper.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _supabaseClient = Get.find<SupabaseClient>();

  RxBool isLoading = false.obs;

  Future register() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = !isLoading.value;

    try {
      final response = await _supabaseClient.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
      );

      await _supabaseClient.from('Users').insert({
        "Id": response.user!.id,
        "DisplayName": displayNameController.text,
        "Email": emailController.text,
      }).catchError((e) {
        throw (e);
      });

      Get.snackbar('Success',
          'Account successfully registered. Email confirmation has been sent.');
      Get.offNamed(Routes.LOGIN);
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
