import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as image_pkg;

import 'add_trx_details_items_controller.dart';

class AddItemOCRController extends GetxController {
  final addTrxDetailItemController = Get.find<AddTrxDetailsItemsController>();
  final imgCropperController = CropController();
  Uint8List? croppedImage;

  Future processOCR() async {
    if (croppedImage == null) return;

    // process image to maximize reading
    // await processImage();

    await readItems();
  }

  Future processImage() async {
    image_pkg.Image grayscaledImg = image_pkg.grayscale(
        image_pkg.decodePng(croppedImage as Uint8List) as image_pkg.Image);

    croppedImage = grayscaledImg.toUint8List();

    update();
  }

  Future readItems() async {
    final tempDirectory = await getTemporaryDirectory();
    File tempFile = await File('${tempDirectory.path}/temp.png').create();
    tempFile.writeAsBytesSync(croppedImage as Uint8List);
    String text = await FlutterTesseractOcr.extractText(
      tempFile.path,
      language: 'ind+eng',
    );
    print(text);
  }
}
