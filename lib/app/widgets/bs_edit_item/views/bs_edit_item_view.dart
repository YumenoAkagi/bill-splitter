import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';
import '../../../utils/validations_helper.dart';
import '../controllers/bs_edit_item_controller.dart';

class BsEditItemView extends StatelessWidget {
  const BsEditItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BsEditItemController());
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15 * GOLDEN_RATIO),
              topRight: Radius.circular(15 * GOLDEN_RATIO),
            ),
            color: Get.isDarkMode
                ? getColorFromHex(COLOR_DARK_MAIN)
                : Colors.white,
          ),
          width: Get.width,
          padding: const EdgeInsets.symmetric(
            horizontal: 10 * GOLDEN_RATIO,
            vertical: 20 * GOLDEN_RATIO,
          ),
          child: Form(
            child: Column(
              children: [
                Text(
                  'Edit Item',
                  style: Get.textTheme.labelMedium?.copyWith(
                    fontSize: 12 * GOLDEN_RATIO,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 12 * GOLDEN_RATIO,
                ),
                TextFormField(
                  controller: controller.itemNameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                  textCapitalization: TextCapitalization.words,
                  validator: RequiredValidator(errorText: requiredErrorText),
                ),
                const SizedBox(
                  height: 10 * GOLDEN_RATIO,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Quantity',
                            style: Get.textTheme.labelMedium,
                          ),
                          const SizedBox(
                            height: 3 * GOLDEN_RATIO,
                          ),
                          TextFormField(
                            controller: controller.qtyController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Quantity',
                            ),
                            inputFormatters: [
                              DecimalFormatter(
                                decimalDigits: 0,
                                maxVal: double.maxFinite,
                              ),
                            ],
                            validator: qtyAndPriceValidator,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5 * GOLDEN_RATIO,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Item Price',
                            style: Get.textTheme.labelMedium,
                          ),
                          const SizedBox(
                            height: 3 * GOLDEN_RATIO,
                          ),
                          TextFormField(
                            controller: controller.itemPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '0.0',
                              prefixText: 'Rp ',
                            ),
                            textAlign: TextAlign.end,
                            inputFormatters: [
                              DecimalFormatter(
                                maxVal: double.maxFinite,
                              ),
                            ],
                            validator: qtyAndPriceValidator,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20 * GOLDEN_RATIO,
                ),
                Obx(
                  () => FilledButton.icon(
                    onPressed: controller.isLoading.isFalse
                        ? controller.editItem
                        : null,
                    icon: controller.isLoading.isFalse
                        ? const Icon(Entypo.floppy)
                        : showCustomCircularProgressIndicator(),
                    label: controller.isLoading.isFalse
                        ? const Text('Save')
                        : const Text('Saving...'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
