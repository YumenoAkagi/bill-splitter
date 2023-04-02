import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';

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

      showSuccessSnackbar('Success',
          'Account successfully registered. Email confirmation has been sent.');
      Get.offNamed(Routes.LOGIN);
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    } finally {
      isLoading.value = false;
    }
  }
}
