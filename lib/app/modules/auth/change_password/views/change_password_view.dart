import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../../../../utils/validations_helper.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: CONTAINER_MARGIN_HORIZONTAL,
            vertical: CONTAINER_MARGIN_VERTICAL,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/undraw_My_password.png',
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  Text(
                    "New Password",
                    style: Get.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 2 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: controller.newPasswordController,
                    decoration: const InputDecoration(
                      hintText: 'New Password',
                    ),
                    validator: strongPasswordValidator,
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  Text(
                    "Confirm Password",
                    style: Get.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 2 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
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
                    height: 10 * GOLDEN_RATIO,
                  ),
                  Obx(
                    () => controller.isLoading.isFalse
                        ? FilledButton(
                            onPressed: () async {
                              await controller.submitNewPassword();
                            },
                            child: const Text('Change Password'),
                          )
                        : FilledButton.icon(
                            onPressed: null,
                            icon: showCustomCircularProgressIndicator(),
                            label: const Text('Processing...'),
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
