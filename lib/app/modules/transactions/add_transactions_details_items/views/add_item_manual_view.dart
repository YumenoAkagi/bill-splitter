import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../../../../utils/validations_helper.dart';
import '../controllers/add_item_manual_controller.dart';

class AddItemManualView extends GetView<AddItemManualController> {
  const AddItemManualView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Item'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: SAFEAREA_CONTAINER_MARGIN_H,
            vertical: SAFEAREA_CONTAINER_MARGIN_V,
          ),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Item Name',
                    style: Get.textTheme.labelMedium,
                  ),
                  const SizedBox(
                    height: 3 * GOLDEN_RATIO,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    controller: controller.nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                    textCapitalization: TextCapitalization.words,
                    maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
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
                              textInputAction: TextInputAction.next,
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
                              onChanged: (_) =>
                                  controller.recalculateMaxDiscount(),
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
                              textInputAction: TextInputAction.next,
                              controller: controller.priceController,
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
                              onChanged: (_) =>
                                  controller.recalculateMaxDiscount(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10 * GOLDEN_RATIO,
                  ),
                  Text(
                    'Item Discount (Optional)',
                    style: Get.textTheme.labelMedium,
                  ),
                  const SizedBox(
                    height: 3 * GOLDEN_RATIO,
                  ),
                  Obx(
                    () => TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: controller.discountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '0.0',
                        prefixText: 'Rp ',
                      ),
                      textAlign: TextAlign.end,
                      inputFormatters: [
                        DecimalFormatter(
                          maxVal: controller.maxDiscount.value,
                        ),
                      ],
                      validator: discValidator,
                    ),
                  ),
                  const SizedBox(
                    height: 20 * GOLDEN_RATIO,
                  ),
                  Obx(
                    () => FilledButton.icon(
                      onPressed: controller.isLoading.isFalse
                          ? () async {
                              await controller.addNewItem();
                            }
                          : null,
                      icon: controller.isLoading.isFalse
                          ? const Icon(
                              FontAwesome.floppy,
                              size: BUTTON_ICON_SIZE,
                            )
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
        ),
      ),
    );
  }
}
