import 'package:bill_splitter/app/modules/walkthrough/controllers/walkthrough_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';

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
              options: CarouselOptions(autoPlay: true, aspectRatio: 3 / 4),
            ),
          ],
        ),
      ),
    );
  }
}
