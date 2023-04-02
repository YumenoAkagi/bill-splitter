import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import 'app_constants.dart';
import 'validations_helper.dart';

final moneyFormatter = NumberFormat.currency(
  locale: 'id-ID',
  symbol: 'Rp',
);

Future<void> showSuccessSnackbar(String title, String message) async {
  if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
  Get.snackbar(
    snackStyle: SnackStyle.FLOATING,
    backgroundColor: getColorFromHex(COLOR_5),
    colorText: Colors.white,
    title,
    message,
  );
}

Future<void> showUnexpectedErrorSnackbar(Object e) async {
  if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
  Get.snackbar(
    snackStyle: SnackStyle.FLOATING,
    backgroundColor: Colors.red.shade700,
    colorText: Colors.white,
    unexpectedErrorText,
    e.toString(),
  );
}

Future<void> showErrorSnackbar(String message) async {
  if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
  Get.snackbar(
    snackStyle: SnackStyle.FLOATING,
    backgroundColor: Colors.red.shade700,
    colorText: Colors.white,
    'Error',
    message,
  );
}
