import 'package:bill_splitter/app/utils/validations_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';
import '../controllers/bs_add_paid_bill_member_controller.dart';

class BsAddPaidBillMemberView extends StatelessWidget {
  const BsAddPaidBillMemberView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BsAddPaidBillMemberController());

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
                  'Add Member',
                  style: Get.textTheme.labelMedium?.copyWith(
                    fontSize: 12 * GOLDEN_RATIO,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 12 * GOLDEN_RATIO,
                ),
                Text(
                  'Member who paid the bill',
                  style: Get.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 3 * GOLDEN_RATIO,
                ),
                Obx(
                  () => DropdownButtonFormField2(
                    hint: const Text('-- Select Member --'),
                    items: controller.trxMembers
                        .map(
                          (member) => DropdownMenuItem(
                            value: member,
                            child: Text(member.displayName),
                          ),
                        )
                        .toList(),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    buttonStyleData: const ButtonStyleData(
                      height: 35 * GOLDEN_RATIO,
                      padding: EdgeInsets.only(right: 8 * GOLDEN_RATIO),
                    ),
                    isExpanded: true,
                    onChanged: (value) => controller.selectedMember = value,
                    validator: (value) {
                      if (value == null) return requiredErrorText;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10 * GOLDEN_RATIO,
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
                    hintText: 'Amount Paid',
                    prefixText: 'Rp ',
                  ),
                  inputFormatters: [
                    DecimalFormatter(
                      maxVal: double.maxFinite,
                    ),
                  ],
                  validator: qtyAndPriceValidator,
                ),
                const SizedBox(
                  height: 20 * GOLDEN_RATIO,
                ),
                FilledButton.icon(
                  onPressed: controller.addMemberToList,
                  icon: const Icon(
                    FontAwesome.plus,
                    size: 10 * GOLDEN_RATIO,
                  ),
                  label: const Text('Add Member'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
