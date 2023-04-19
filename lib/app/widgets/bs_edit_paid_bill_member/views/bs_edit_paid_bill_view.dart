import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';
import '../../../utils/validations_helper.dart';
import '../controllers/bs_edit_paid_bill_member_controller.dart';

class BsEditPaidMemberView extends StatelessWidget {
  const BsEditPaidMemberView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BsEditPaidBillMemberController());
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit Amount - ${controller.whoPaidController.selectedPayer!.member.displayName}',
                  style: Get.textTheme.labelMedium?.copyWith(
                    fontSize: 12 * GOLDEN_RATIO,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 12 * GOLDEN_RATIO,
                ),
                Text(
                  'Amount Paid',
                  style: Get.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 3 * GOLDEN_RATIO,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: controller.amountPaidController,
                  decoration: const InputDecoration(
                    hintText: '0.0',
                    prefixText: 'Rp ',
                  ),
                  textAlign: TextAlign.end,
                  inputFormatters: [
                    DecimalFormatter(
                      maxVal: controller.maxAmountPaid.value,
                    ),
                  ],
                  validator: qtyAndPriceValidator,
                ),
                const SizedBox(
                  height: 20 * GOLDEN_RATIO,
                ),
                FilledButton.icon(
                  onPressed: controller.editPayAmount,
                  icon: const Icon(
                    FontAwesome.floppy,
                    size: 10 * GOLDEN_RATIO,
                  ),
                  label: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
