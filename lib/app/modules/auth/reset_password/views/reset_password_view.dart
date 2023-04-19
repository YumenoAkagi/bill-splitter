import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/validations_helper.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_NAME),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: SAFEAREA_CONTAINER_MARGIN_H,
            vertical: SAFEAREA_CONTAINER_MARGIN_V,
          ),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/undraw_My_password.png'),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  Text(
                    'Password Reset',
                    style: Get.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    controller: controller.newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(FontAwesome.lock_open),
                      hintText: 'Enter New Password',
                    ),
                    validator: strongPasswordValidator,
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(FontAwesome.lock_open),
                      hintText: 'Confirm Password',
                    ),
                    onChanged: (value) =>
                        controller.confirmPasswordText.value = value,
                    validator: (value) =>
                        MatchValidator(errorText: 'Password does not match.')
                            .validateMatch(
                      controller.confirmPasswordText.value,
                      controller.newPasswordController.text,
                    ),
                  ),
                  const SizedBox(
                    height: 20 * GOLDEN_RATIO,
                  ),
                  Obx(
                    () => FilledButton(
                      onPressed: controller.isLoading.isFalse
                          ? controller.resetPassword
                          : null,
                      child: controller.isLoading.isFalse
                          ? const Text('Save Changes')
                          : const Text('Saving...'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
