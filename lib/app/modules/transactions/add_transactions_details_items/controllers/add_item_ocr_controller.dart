import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bill_splitter/app/models/transaction_detail_item_model.dart';
import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as image_pkg;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../utils/functions_helper.dart';
import 'add_trx_details_items_controller.dart';

class AddItemOCRController extends GetxController {
  final addTrxDetailItemController = Get.find<AddTrxDetailsItemsController>();
  final imgCropperController = CropController();
  Uint8List? croppedImage;

  Future processOCR() async {
    if (croppedImage == null) return;

    final ctx = Get.context as BuildContext;
    try {
      await preprocessImage();

      await readItems();

      addTrxDetailItemController.recalculateSubtotal();
      addTrxDetailItemController.update();
      Get.back();
      await showSuccessSnackbar('Success',
          'Items successfully added!\nPlease check the inserted items again.');
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    } finally {
      ctx.loaderOverlay.hide();
    }
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
      List<double> numbers = [];
      final words = line.trim().split(RegExp(' '));
      for (final word in words) {
        if (!word.contains(' ')) {
          if (word.contains(RegExp(r'\d+')) && word.isNotEmpty) {
            final number = word.replaceAll(RegExp(r'\D+'), '');
            final parsed = double.tryParse(number);
            if ((parsed ?? 0.0) > 0.0) {
              numbers.add(double.parse(number));
            }
          } else {
            itemName += '$word ';
          }
        }
      }

      if (numbers.length >= 2) {
        // have at least qty and price
        // all string become item name
        itemName = itemName.trim();
        itemName = itemName.replaceAll(RegExp(r'\s{2,}'), ' ');

        // get least number -> make it as qty
        // get largest number -> make it as total price
        numbers.sort();
        qty = numbers.first;
        itemPrice = numbers.last / qty; // item price = total / qty

        // print('======================');
        // print('Item Name: $itemName');
        // print('Item Qty: $qty');
        // print('Item Price: $itemPrice');
        // print('======================');

        final response = await supabaseClient
            .from('TransactionDetail')
            .insert({
              'TransactionId': addTrxDetailItemController.trxHeader.id,
              'Name': itemName,
              'Quantity': qty,
              'Price': itemPrice,
              'TotalPrice': numbers.last,
            })
            .select()
            .single();

        addTrxDetailItemController.detailItemsList.add(
          TransactionDetailItemModel(
            id: response['Id'],
            transactionId: response['TransactionId'],
            name: response['Name'],
            qty: response['Quantity'],
            price: response['Price'],
            totalPrice: response['TotalPrice'],
          ),
        );
      }
    }
  }
}
