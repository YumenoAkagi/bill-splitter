import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/transaction_header_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';
import '../../../utils/validations_helper.dart';
import '../controllers/add_transaction_bs_controller.dart';

class AddTransactionBottomSheet extends StatelessWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddTransactionBsController());
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
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add Transaction',
                  style: Get.textTheme.labelMedium?.copyWith(
                    fontSize: 12 * GOLDEN_RATIO,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 12 * GOLDEN_RATIO,
                ),
                Text(
                  'Transaction Name',
                  style: Get.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 3 * GOLDEN_RATIO,
                ),
                TextFormField(
                  controller: controller.nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                  validator: RequiredValidator(errorText: requiredErrorText),
                ),
                const SizedBox(
                  height: 12 * GOLDEN_RATIO,
                ),
                Text(
                  'Transaction Date',
                  style: Get.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 3 * GOLDEN_RATIO,
                ),
                TextFormField(
                  controller: controller.selectDateController,
                  validator: RequiredValidator(errorText: requiredErrorText),
                  readOnly: true,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(FontAwesome.calendar),
                      hintText: 'Tap to select date'),
                  onTap: () async {
                    final selectedDate = await showCalendarDatePicker2Dialog(
                      context: context,
                      config: CalendarDatePicker2WithActionButtonsConfig(
                        lastDate: DateTime.now(),
                        firstDayOfWeek: 1,
                        selectedDayHighlightColor: getColorFromHex(COLOR_1),
                        controlsTextStyle: Get.textTheme.labelMedium,
                      ),
                      dialogSize: Size(
                        Get.width * 0.7 * GOLDEN_RATIO,
                        400,
                      ),
                      value: [controller.selectedDate],
                    );

                    controller.selectDateController.text = selectedDate != null
                        ? (selectedDate[0] != null
                            ? DateFormat('dd MMM yyyy').format(selectedDate[0]!)
                            : controller.selectDateController.text)
                        : controller.selectDateController.text;

                    if (selectedDate != null && selectedDate[0] != null) {
                      controller.setDate(selectedDate[0]);
                    }
                  },
                ),
                const SizedBox(
                  height: 20 * GOLDEN_RATIO,
                ),
                Obx(
                  () => FilledButton.icon(
                    onPressed: controller.isLoading.isFalse
                        ? () async {
                            final header = await controller.addTransaction();
                            if (header == null) return;
                            await showConfirmDialog(
                              Get.context,
                              'You have created a new transaction.\nDo you want to open the transaction created?',
                              negativeText: 'No',
                              positiveText: 'Yes',
                              buttonColor: Get.isDarkMode
                                  ? null
                                  : getColorFromHex(COLOR_1),
                              onAccept: () {
                                Get.toNamed(Routes.ADDTRXITEM,
                                    arguments: header as TransactionHeader);
                              },
                            );
                          }
                        : null,
                    icon: controller.isLoading.isFalse
                        ? const Icon(
                            FontAwesome.plus,
                            size: 10 * GOLDEN_RATIO,
                          )
                        : showCustomCircularProgressIndicator(),
                    label: controller.isLoading.isFalse
                        ? const Text('Add New Transaction')
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
