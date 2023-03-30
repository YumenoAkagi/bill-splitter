import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../utils/app_constants.dart';
import '../controllers/add_transaction_bs_controller.dart';

class AddTransactionBottomSheet extends StatelessWidget {
  AddTransactionBottomSheet({super.key});
  final controller = Get.put(AddTransactionBsController());

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          color:
              Get.isDarkMode ? getColorFromHex(COLOR_DARK_MAIN) : Colors.white,
          width: Get.width,
          padding: const EdgeInsets.symmetric(
            horizontal: 10 * GOLDEN_RATIO,
            vertical: 20 * GOLDEN_RATIO,
          ),
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
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
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
                readOnly: true,
                decoration: const InputDecoration(
                    prefixIcon: Icon(FontAwesome.calendar),
                    hintText: 'Tap to select date'),
                onTap: () async {
                  final selectedDate = await showCalendarDatePicker2Dialog(
                    context: context,
                    config: CalendarDatePicker2WithActionButtonsConfig(
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
                },
              ),
              const SizedBox(
                height: 25 * GOLDEN_RATIO,
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(
                  FontAwesome.plus,
                  size: 10 * GOLDEN_RATIO,
                ),
                label: const Text('Add New Transaction'),
              )
            ],
          ),
        ),
      ],
    );
  }
}
