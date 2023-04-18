import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../../../../utils/validations_helper.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

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
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/undraw_signUp.png',
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  Text(
                    'Sign Up',
                    style: Get.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    controller: controller.displayNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      icon: Icon(
                        FontAwesome.user,
                      ),
                      hintText: 'Display Name',
                    ),
                    validator: RequiredValidator(errorText: requiredErrorText),
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      icon: Icon(
                        FontAwesome.mail,
                      ),
                      hintText: 'Email',
                    ),
                    validator: emailValidator,
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(
                        FontAwesome.lock_open,
                      ),
                      hintText: 'Password',
                    ),
                    validator: strongPasswordValidator,
                  ),
                  const SizedBox(
                    height: 20 * GOLDEN_RATIO,
                  ),
                  Obx(
                    () => controller.isLoading.isFalse
                        ? FilledButton(
                            onPressed: () async {
                              await controller.register();
                            },
                            child: const Text('Register'),
                          )
                        : FilledButton.icon(
                            onPressed: null,
                            icon: showCustomCircularProgressIndicator(),
                            label: const Text('Loading...'),
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
