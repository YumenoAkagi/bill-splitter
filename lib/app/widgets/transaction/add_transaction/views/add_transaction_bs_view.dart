import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:bill_splitter/app/widgets/transaction/add_transaction/controllers/add_transaction_bs_controller.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';

class AddTransactionBottomSheet extends GetView<AddTransactionBsController> {
  const AddTransactionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      height: 200 * GOLDEN_RATIO,
      width: Get.width,
      child: Row(children: [
        Text(
          'Add Transaction',
          style:
              Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: controller.nameController,
          decoration: const InputDecoration(
            hintText: 'Name',
          ),
        ),
        CalendarDatePicker2(
          value: [
            DateTime.now(),
          ],
          config: CalendarDatePicker2Config(),
          onValueChanged: controller.setDate,
        )
      ]),
    );
  }
}
