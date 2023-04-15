import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';
import '../../../utils/validations_helper.dart';
import '../controllers/bs_add_trx_proof_controller.dart';

class BsAddTrxProofView extends StatelessWidget {
  const BsAddTrxProofView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BsAddTrxProofController());
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
                  'Add Payment Confirmation',
                  textAlign: TextAlign.center,
                  style: Get.textTheme.labelMedium?.copyWith(
                    fontSize: 12 * GOLDEN_RATIO,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 12 * GOLDEN_RATIO,
                ),
                Text(
                  'To',
                  style: Get.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 3 * GOLDEN_RATIO,
                ),
                Obx(
                  () => DropdownButtonFormField2(
                    hint: const Text('-- Select Recipient --'),
                    items: controller.trxUsersList
                        .map(
                          (tu) => DropdownMenuItem(
                            value: tu,
                            child: Text(tu.toUser.displayName),
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
                    onChanged: controller.setSelectedRecipient,
                    validator: (value) {
                      if (value == null) return requiredErrorText;
                    },
                  ),
                ),
                const SizedBox(
                  height: 12 * GOLDEN_RATIO,
                ),
                Text(
                  'Amount',
                  style: Get.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 3 * GOLDEN_RATIO,
                ),
                Obx(
                  () => TextFormField(
                    keyboardType: TextInputType.number,
                    enabled: controller.selectedTrxUser != null,
                    controller: controller.amountPaidController,
                    decoration: const InputDecoration(
                      hintText: '0.0',
                      prefixText: 'Rp ',
                    ),
                    textAlign: TextAlign.end,
                    inputFormatters: [
                      DecimalFormatter(
                        maxVal: controller.remainingAmount.value, // change soon
                      ),
                    ],
                    validator: qtyAndPriceValidator,
                  ),
                ),
                const SizedBox(
                  height: 12 * GOLDEN_RATIO,
                ),
                Text(
                  'Image (Optional)',
                  style: Get.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 3 * GOLDEN_RATIO,
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GetBuilder<BsAddTrxProofController>(
                          builder: (batpc) => Text(
                            controller.selectedImg?.name ?? 'No image selected',
                            style: Get.textTheme.labelSmall
                                ?.copyWith(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.3 * GOLDEN_RATIO,
                        child: Obx(
                          () => OutlinedButton.icon(
                            onPressed: controller.remainingAmount > 0.0
                                ? controller.pickImage
                                : null,
                            icon: const Icon(
                              FontAwesome.picture,
                              size: 10 * GOLDEN_RATIO,
                            ),
                            label: const Text('Select Image'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20 * GOLDEN_RATIO,
                ),
                Obx(
                  () => FilledButton.icon(
                    onPressed: controller.isLoading.isFalse
                        ? () async {
                            await showConfirmDialog(
                              context,
                              'Submit Payment Confirmation?\nMake sure the recipient and amount is correct.',
                              positiveText: 'Submit',
                              negativeText: 'Cancel',
                              onAccept: controller.addTransactionProof,
                            );
                          }
                        : null,
                    icon: controller.isLoading.isFalse
                        ? const Icon(
                            FontAwesome.floppy,
                            size: 10 * GOLDEN_RATIO,
                          )
                        : showCustomCircularProgressIndicator(),
                    label: controller.isLoading.isFalse
                        ? const Text('Save')
                        : const Text('Saving...'),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
