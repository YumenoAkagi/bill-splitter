import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future<void> sendPasswordRecoveryEmail() async {
    if (!formKey.currentState!.validate()) return;
  }
}
