import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';

class ConfigsController extends GetxController {
  final strg = Get.find<GetStorage>();
  RxBool isDarkMode = false.obs;

  void switchTheme() async {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    await strg.write(THEME_KEY, Get.isDarkMode ? 'Light' : 'Dark');
    isDarkMode.value = !isDarkMode.value;
    isDarkMode.isTrue
        ? textPrimaryColorGlobal = Colors.white
        : textPrimaryColorGlobal = getColorFromHex(COLOR_2);
  }

  @override
  void onReady() async {
    super.onReady();
    isDarkMode.value = Get.isDarkMode ? true : false;
  }
}
