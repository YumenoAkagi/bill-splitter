import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
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
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: SAFEAREA_CONTAINER_MARGIN_H,
            vertical: SAFEAREA_CONTAINER_MARGIN_V,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: CarouselSlider(
                  items: controller.imageWithTextList,
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2 / 3,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                  ),
                ),
              ),
              const SizedBox(
                height: 5 * GOLDEN_RATIO,
              ),
              SizedBox(
                height: Get.height * 0.1 * GOLDEN_RATIO,
                child: Column(
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        Get.toNamed(Routes.REGISTER);
                      },
                      icon: const Icon(
                        FontAwesome.mail,
                        size: BUTTON_ICON_SIZE,
                      ),
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
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
