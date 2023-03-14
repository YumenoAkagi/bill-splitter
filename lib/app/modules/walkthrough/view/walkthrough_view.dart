import '../../../routes/app_pages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';

import '../../../utils/app_constants.dart';
import '../controllers/walkthrough_controller.dart';

class WalkthroughView extends GetView<WalkthroughController> {
  const WalkthroughView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_NAME),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            CarouselSlider(
              items: controller.imageWithTextList,
              options: CarouselOptions(
                autoPlay: true,
                height: Get.height * 0.4 * GOLDEN_RATIO,
              ),
            ),
            const SizedBox(
              height: 10 * GOLDEN_RATIO,
            ),
            FilledButton.icon(
              onPressed: () {
                Get.toNamed(Routes.REGISTER);
              },
              icon: const Icon(Entypo.mail),
              label: const Text('Sign Up With Email'),
            ),
            const SizedBox(
              height: 10 * GOLDEN_RATIO,
            ),
            OutlinedButton(
              onPressed: () {
                Get.offNamed(Routes.LOGIN);
              },
              child: const Text.rich(
                TextSpan(
                  text: "Already Have Account? ",
                  children: <TextSpan>[
                    TextSpan(
                      text: "Sign In",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
