import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../controllers/configs_controller.dart';

class ConfigsView extends GetView<ConfigsController> {
  const ConfigsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offNamed(Routes.HOME);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: SAFEAREA_CONTAINER_MARGIN_H,
            vertical: SAFEAREA_CONTAINER_MARGIN_V,
          ),
          child: Column(
            children: [
              Obx(
                () => ListTileSwitch(
                  leading: Icon(
                    controller.isDarkMode.isFalse
                        ? FontAwesome.moon
                        : FontAwesome.sun,
                  ),
                  switchActiveColor: getColorFromHex(COLOR_1),
                  title: const Text(
                    'Toggle Dark/Light Mode',
                  ),
                  subtitle: const Text(
                    'Switch between dark and light mode',
                    style: TextStyle(
                      fontSize: 8 * GOLDEN_RATIO,
                    ),
                  ),
                  onChanged: (_) => controller.switchTheme(),
                  value: controller.isDarkMode.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
