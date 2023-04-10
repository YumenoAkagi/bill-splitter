import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import 'app_constants.dart';
import 'validations_helper.dart';

final moneyFormatter = NumberFormat.currency(
  locale: 'id-ID',
  symbol: 'Rp',
);

final separatorFormatter = NumberFormat("#,##0.##");

class DecimalFormatter extends TextInputFormatter {
  final int decimalDigits;
  final double minVal;
  final double maxVal;

  DecimalFormatter(
      {this.decimalDigits = 2, this.minVal = 0.0, required this.maxVal})
      : assert(decimalDigits >= 0, minVal < maxVal);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText;

    if (decimalDigits == 0) {
      newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    } else {
      newText = newValue.text.replaceAll(RegExp('[^0-9.]'), '');
    }

    if (newText.contains('.')) {
      //in case if user's first input is "."
      if (newText.trim() == '.') {
        return newValue.copyWith(
          text: '0.',
          selection: const TextSelection.collapsed(offset: 2),
        );
      }
      //in case if user tries to input multiple "."s or tries to input
      //more than the decimal place
      else if ((newText.split(".").length > 2) ||
          (newText.split(".")[1].length > decimalDigits)) {
        return oldValue;
      }
      return newValue;
    }

    if (newText.isEmpty) return newValue;

    double newDouble = double.parse(newText);
    var selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;

    String newString = NumberFormat("#,##0.##").format(newDouble);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
        offset: newString.length - selectionIndexFromTheRight,
      ),
    );
  }
}

SizedBox showCustomCircularProgressIndicator() {
  return SizedBox(
    width: 10 * GOLDEN_RATIO,
    height: 10 * GOLDEN_RATIO,
    child: CircularProgressIndicator(
      color: getColorFromHex(COLOR_1),
    ),
  );
}

Widget showFetchingScreen() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        showCustomCircularProgressIndicator(),
        const SizedBox(
          height: 10 * GOLDEN_RATIO,
        ),
        Text(
          retrievingDataStatusTxt,
          style: Get.textTheme.labelSmall,
        ),
      ],
    ),
  );
}

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
