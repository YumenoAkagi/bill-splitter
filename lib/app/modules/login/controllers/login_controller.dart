import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> loginWithEmailPassword() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = !isLoading.value;
  }
}
