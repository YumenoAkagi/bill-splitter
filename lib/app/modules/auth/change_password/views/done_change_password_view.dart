import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../controllers/done_change_password_controller.dart';

class DoneChangePasswordView extends GetView<DoneChangePassController> {
  const DoneChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: CONTAINER_MARGIN_HORIZONTAL,
            vertical: CONTAINER_MARGIN_VERTICAL,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/undraw_Done.png',
                ),
                const SizedBox(
                  height: 10 * GOLDEN_RATIO,
                ),
                Center(
                  child: Text(
                    "Done",
                    style: Get.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5 * GOLDEN_RATIO,
                ),
                Center(
                  child: Text(
                    "Your password has been changed",
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(
                  height: 10 * GOLDEN_RATIO,
                ),
                Obx(
                  () => controller.isLoading.isFalse
                      ? FilledButton(
                          onPressed: () async {
                            await controller.pressDoneButton();
                          },
                          child: const Text('Back to Profile'),
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
    );
  }
}
