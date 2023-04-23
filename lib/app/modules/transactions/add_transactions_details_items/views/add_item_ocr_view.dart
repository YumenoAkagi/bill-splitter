import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../utils/app_constants.dart';
import '../controllers/add_item_ocr_controller.dart';

class AddItemOCRView extends GetView<AddItemOCRController> {
  const AddItemOCRView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Image'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: SAFEAREA_CONTAINER_MARGIN_H,
            vertical: SAFEAREA_CONTAINER_MARGIN_V,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select the part of the image you want to scan',
                style: Get.textTheme.labelMedium,
              ),
              const SizedBox(
                height: 3 * GOLDEN_RATIO,
              ),
              Text(
                'Please make sure the text should be seen clearly part should consists of item name, quantity, and price for this app to work properly.',
                style: Get.textTheme.labelSmall,
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
              Expanded(
                child: Crop(
                  controller: controller.imgCropperController,
                  image: controller.addTrxDetailItemController.selectedImage!,
                  onCropped: (img) async {
                    controller.croppedImage = img;
                    await controller.processOCR();
                  },
                ),
              ),
              const SizedBox(
                height: 20 * GOLDEN_RATIO,
              ),
              FilledButton.icon(
                onPressed: () {
                  context.loaderOverlay.show();
                  controller.imgCropperController.crop();
                },
                icon: const Icon(FontAwesome.crop),
                label: const Text('Crop and Scan'),
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
