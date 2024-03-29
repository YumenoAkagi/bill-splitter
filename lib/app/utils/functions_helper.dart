import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'app_constants.dart';
import 'enums.dart';
import 'validations_helper.dart';

Future<void> sendNotification(
    List<String> userIds, String title, String message) async {
  try {
    final devState = await OneSignal.shared.getDeviceState();
    if (devState == null || devState.userId == null) return;

    final uri = Uri.parse('https://api.onesignal.com/notifications/');
    final headers = {
      'Authorization': "Basic ${dotenv.env['ONESIGNAL_REST_API_KEY']}",
      'Content-Type': 'application/json',
    };
    final body = {
      'app_id': dotenv.env['ONESIGNAL_APP_ID'],
      'include_external_user_ids': userIds,
      'contents': {'en': message},
      'headings': {'en': title},
    };

    await http.post(uri, headers: headers, body: json.encode(body));
  } catch (e) {
    // do nothing
  }
}

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
    if (newDouble > maxVal) newDouble = maxVal;
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
    width: 12 * GOLDEN_RATIO,
    height: 12 * GOLDEN_RATIO,
    child: CircularProgressIndicator(
      color: getColorFromHex(COLOR_1),
    ),
  );
}

Widget showCustomHandleBar() {
  return FractionallySizedBox(
    widthFactor: 0.25,
    child: Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10 * GOLDEN_RATIO,
      ),
      child: Container(
        height: 3 * GOLDEN_RATIO,
        decoration: BoxDecoration(
          color: Get.theme.dividerColor,
          borderRadius: const BorderRadius.all(Radius.circular(2.5)),
        ),
      ),
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

Future<ImagePickMethod?> askImagePickMethod(BuildContext ctx) async {
  ImagePickMethod? result;
  result = await showDialog<ImagePickMethod>(
    context: ctx,
    builder: (context) => SimpleDialog(
      children: [
        SimpleDialogOption(
          onPressed: () {
            Get.back(result: ImagePickMethod.camera);
          },
          child: Row(
            children: const [
              Icon(
                FontAwesome.camera_alt,
              ),
              SizedBox(
                width: 10 * GOLDEN_RATIO,
              ),
              Text('Take a Photo'),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Get.back(result: ImagePickMethod.gallery);
          },
          child: Row(
            children: const [
              Icon(
                FontAwesome.picture,
              ),
              SizedBox(
                width: 10 * GOLDEN_RATIO,
              ),
              Text('Pick from Gallery'),
            ],
          ),
        ),
      ],
    ),
  );
  return result;
}
