import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../../../../utils/validations_helper.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
                  Image.asset('assets/images/undraw_Forgot_password.png'),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  Text(
                    'Forgot Password',
                    style: Get.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter email address',
                      icon: Icon(FontAwesome.mail),
                    ),
                    validator: emailValidator,
                  ),
                  const SizedBox(
                    height: 5 * GOLDEN_RATIO,
                  ),
                  Text(
                    "Type in your email and we'll send you a link to reset your password",
                    style: Get.textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 20 * GOLDEN_RATIO,
                  ),
                  Obx(() => FilledButton.icon(
                        onPressed: controller.isLoading.isFalse
                            ? () async {
                                await controller.sendPasswordRecoveryEmail();
                              }
                            : null,
                        icon: controller.isLoading.isFalse
                            ? const Icon(
                                FontAwesome.paper_plane,
                                size: BUTTON_ICON_SIZE,
                              )
                            : showCustomCircularProgressIndicator(),
                        label: controller.isLoading.isFalse
                            ? const Text('Send Password Reset Link')
                            : const Text('Sending email...'),
                      )),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Back to Login Page'),
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
