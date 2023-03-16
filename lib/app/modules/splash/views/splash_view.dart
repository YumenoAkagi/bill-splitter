import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex(COLOR_3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bill Splitter',
              style: Get.textTheme.titleLarge,
            ),
            Text(
              'An easy way to split your bill',
              style: Get.textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
