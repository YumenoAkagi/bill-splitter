import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  SplashView({super.key});

  @override
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 150 * GOLDEN_RATIO,
              height: 150 * GOLDEN_RATIO,
              child: Image.asset('assets/logo/BS_icon.png'),
            ),
            Text(
              'Bill-Splitter',
              style: Get.textTheme.titleLarge?.copyWith(
                color: getColorFromHex(COLOR_2),
                fontSize: 20 * GOLDEN_RATIO,
              ),
            ),
            Text(
              'An easy way to split your bill',
              style: Get.textTheme.titleSmall?.copyWith(
                color: getColorFromHex(COLOR_1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
