import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../../../../utils/validations_helper.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
                    'assets/images/undraw_Login.png',
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  Text(
                    'Login',
                    style: Get.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    controller: controller.emailController,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration: const InputDecoration(
                      icon: Icon(FontAwesome.mail),
                      hintText: 'Enter email address',
                    ),
                    validator: emailValidator,
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter password',
                      icon: Icon(FontAwesome.lock_open),
                    ),
                    validator: RequiredValidator(errorText: requiredErrorText),
                  ),
                  const SizedBox(
                    height: 3 * GOLDEN_RATIO,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Obx(
                      () => controller.isLoading.isFalse
                          ? TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.FORGOT_PASSWORD);
                              },
                              child: Text(
                                'Forgot Password?',
                                style: Get.textTheme.titleSmall,
                              ),
                            )
                          : const TextButton(
                              onPressed: null,
                              child: Text('Forgot Password?'),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20 * GOLDEN_RATIO,
                  ),
                  Obx(
                    () => controller.isLoading.isFalse
                        ? FilledButton(
                            onPressed: () async {
                              await controller.loginWithEmailPassword();
                            },
                            child: const Text('Login'),
                          )
                        : FilledButton.icon(
                            onPressed: null,
                            icon: showCustomCircularProgressIndicator(),
                            label: const Text('Signing in...'),
                          ),
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  Obx(
                    () => controller.isLoading.isFalse
                        ? OutlinedButton(
                            onPressed: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: const Text.rich(
                              TextSpan(
                                text: "Don't have account? ",
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const OutlinedButton(
                            onPressed: null,
                            child: Text.rich(
                              TextSpan(
                                text: "Don't have account? ",
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
