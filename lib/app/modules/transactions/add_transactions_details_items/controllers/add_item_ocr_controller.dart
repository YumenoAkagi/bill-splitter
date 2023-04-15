import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bill_splitter/app/utils/functions_helper.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as image_pkg;
import 'package:image_picker/image_picker.dart' as image_pkg;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';

import 'add_trx_details_items_controller.dart';

class AddItemOCRController extends GetxController {
  final addTrxDetailItemController = Get.find<AddTrxDetailsItemsController>();
  final imgCropperController = CropController();
  Uint8List? croppedImage;

  Future processOCR() async {
    if (croppedImage == null) return;

    final ctx = Get.context as BuildContext;
    ctx.loaderOverlay.show();
    try {
      await preprocessImage();

      await readItems();
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    } finally {
      ctx.loaderOverlay.hide();
    }
    // preprocess image to maximize reading
  }

  Future preprocessImage() async {
    // grayscaling & binarization
    final decodedImg = image_pkg.decodeImage(croppedImage as Uint8List);
    image_pkg.Image grayscaledImg = image_pkg.grayscale(decodedImg!);
    final binarizedImage = image_pkg.copyResize(
      grayscaledImg,
      width: decodedImg.width ~/ 2,
      height: decodedImg.height ~/ 2,
    );
    final thresholdImage = image_pkg.luminanceThreshold(binarizedImage);

    final enhancedImg =
        image_pkg.adjustColor(thresholdImage, contrast: 1.5, saturation: 1.5);

    croppedImage = image_pkg.encodePng(enhancedImg);
    update();
  }

  Future readItems() async {
    final tempDirectory = await getTemporaryDirectory();
    File tempFile = await File('${tempDirectory.path}/temp.png').create();
    tempFile.writeAsBytesSync(croppedImage as Uint8List);
    String text = await FlutterTesseractOcr.extractText(tempFile.path,
        language: 'ind+eng',
        args: {
          "psm": "4",
          "preserve_interword_spaces": "1",
        });

    final textPerLine = text.split('\n');

    for (final line in textPerLine) {
      double qty = 0.0;
      double itemPrice = 0.0;
      String itemName = '';
      final words = line.trim().split(RegExp(r'\s{2,}'));
      for (final word in words) {
        final isItemName = word.startsWith(RegExp(r'[a-zA-Z]'));
        if (isItemName) {
          // the result is item name
          itemName = word;
        } else {
          // the result is either item price or qty
          // see if can split further
          final numSplitted = word.split(' ');
          for (final number in numSplitted) {
            if (qty <= 0.0 || itemPrice <= 0.0) {
              final converted = double.tryParse(number);
              if (converted != null && converted < 1000.0 && qty <= 0.0) {
                qty = converted.abs();
              } else if (converted != null &&
                  converted > 1000.0 &&
                  itemPrice <= 0.0) {
                itemPrice = converted.abs();
              }
            }
          }
        }
      }
      print('Item Name: $itemName');
      print('Item Qty: $qty');
      print('Item Price: $itemPrice');
    }
  }
}
