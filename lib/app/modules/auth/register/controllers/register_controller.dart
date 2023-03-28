import 'dart:async';

import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/validations_helper.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    displayNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future register() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = !isLoading.value;

    try {
      final response = await supabaseClient.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
        emailRedirectTo: kIsWeb
            ? null
            : 'com.binus.skripsi.billsplitter://url-callback/', // api callback
      );

      await supabaseClient.from('Users').insert({
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
