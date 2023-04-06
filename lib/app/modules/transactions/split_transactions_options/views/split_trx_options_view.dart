import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../utils/app_constants.dart';
import '../controllers/split_trx_options_controller.dart';

class SplitTrxOptionsView extends GetView<SplitTrxOptionsController> {
  const SplitTrxOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.trxHeader.name),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: SAFEAREA_CONTAINER_MARGIN_H,
            vertical: SAFEAREA_CONTAINER_MARGIN_V,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'How do you want to split the bill?',
                style: Get.textTheme.labelLarge
                    ?.copyWith(fontSize: 12 * GOLDEN_RATIO),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15 * GOLDEN_RATIO,
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(BUTTON_BORDER_RAD),
                  onTap: () {},
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(BUTTON_BORDER_RAD),
                      side: BorderSide(
                        color: Get.isDarkMode
                            ? Colors.white
                            : getColorFromHex(COLOR_1),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          FontAwesome.balance_scale,
                          size: 30 * GOLDEN_RATIO,
                          color:
                              Get.isDarkMode ? null : getColorFromHex(COLOR_2),
                        ),
                        const SizedBox(
                          height: 15 * GOLDEN_RATIO,
                        ),
                        Text(
                          'Split Equally',
                          style: Get.textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8 * GOLDEN_RATIO,
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(BUTTON_BORDER_RAD),
                  onTap: () {},
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(BUTTON_BORDER_RAD),
                      side: BorderSide(
                        color: Get.isDarkMode
                            ? Colors.white
                            : getColorFromHex(COLOR_1),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          FontAwesome.shopping_basket,
                          size: 30 * GOLDEN_RATIO,
                          color:
                              Get.isDarkMode ? null : getColorFromHex(COLOR_2),
                        ),
                        const SizedBox(
                          height: 15 * GOLDEN_RATIO,
                        ),
                        Text(
                          'Split per Item',
                          style: Get.textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              )
            ],
          ),
        ),
      ),
    );
  }
}
