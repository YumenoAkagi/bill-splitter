import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';
import '../controllers/split_success_controller.dart';

class SplitSuccessView extends GetView<SplitSuccessController> {
  const SplitSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: SAFEAREA_CONTAINER_MARGIN_H,
          vertical: SAFEAREA_CONTAINER_MARGIN_V,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Success',
              style: Get.textTheme.labelMedium?.copyWith(
                fontSize: 14 * GOLDEN_RATIO,
              ),
            ),
            const SizedBox(
              height: 10 * GOLDEN_RATIO,
            ),
            Image.asset(
              'assets/images/undraw_Done.png',
              width: Get.width * 0.45 * GOLDEN_RATIO,
            ),
            const SizedBox(
              height: 15 * GOLDEN_RATIO,
            ),
            Text(
              'Transactions splitted. You can check this transaction in the active tab.',
              style: Get.textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20 * GOLDEN_RATIO,
            ),
            FilledButton(
              onPressed: controller.returnToHomePage,
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
