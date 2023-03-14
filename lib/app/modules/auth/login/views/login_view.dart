import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/validations_helper.dart';

import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';

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
                    decoration: const InputDecoration(
                      icon: Icon(Entypo.mail),
                      hintText: 'Enter email address',
                    ),
                    validator: isEmailValid,
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter password',
                      icon: Icon(Entypo.lock_open),
                    ),
                    validator: isNotEmptyString,
                  ),
                  const SizedBox(
                    height: 3 * GOLDEN_RATIO,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Obx(
                      () => controller.isLoading.isFalse
                          ? TextButton(
                              onPressed: () {},
                              child: const Text('Forgot Password?'),
                            )
                          : const TextButton(
                              onPressed: null,
                              child: Text('Forgot Password?'),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
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
                            icon: const SizedBox(
                              width: 10 * GOLDEN_RATIO,
                              height: 10 * GOLDEN_RATIO,
                              child: CircularProgressIndicator(),
                            ),
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
