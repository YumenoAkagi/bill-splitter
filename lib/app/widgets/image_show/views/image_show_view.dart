import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../controllers/image_show_controller.dart';

class ImageShowView extends GetView<ImageShowController> {
  const ImageShowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FullScreenWidget(
        backgroundColor: Get.isDarkMode
            ? getColorFromHex(COLOR_DARK_MAIN)
            : getColorFromHex(COLOR_1),
        child: Center(
          child: Hero(
            tag: controller.trxProof.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(controller.trxProof.imgUrl!),
            ),
          ),
        ),
      ),
    );
  }
}
