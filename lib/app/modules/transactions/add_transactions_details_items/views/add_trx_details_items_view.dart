import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../../../../utils/validations_helper.dart';
import '../../../../widgets/bs_edit_item/views/bs_edit_item_view.dart';
import '../controllers/add_trx_details_items_controller.dart';

class AddTrxDetailsItemsView extends GetView<AddTrxDetailsItemsController> {
  const AddTrxDetailsItemsView({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Items List',
                style: Get.textTheme.labelMedium,
              ),
              const SizedBox(
                height: 2 * GOLDEN_RATIO,
              ),
              Text(
                'Manage your transaction items here',
                style: Get.textTheme.labelSmall,
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
              Expanded(
                child: GetBuilder<AddTrxDetailsItemsController>(
                  builder: (trxdc) => trxdc.isFetching
                      ? showFetchingScreen()
                      : trxdc.detailItemsList.isEmpty
                          ? Center(
                              child: Text(
                                'No items added',
                                style: Get.textTheme.labelSmall,
                              ),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: trxdc.detailItemsList.length,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () async {
                                  controller.selectedItem =
                                      trxdc.detailItemsList[index];
                                  await Get.bottomSheet(const BsEditItemView());
                                },
                                onLongPress: () async {
                                  await showConfirmDialog(
                                    context,
                                    'Delete selected item?',
                                    negativeText: 'Cancel',
                                    positiveText: 'Delete',
                                    buttonColor: Colors.red.shade700,
                                    onAccept: () async {
                                      await trxdc.removeItem(
                                          trxdc.detailItemsList[index].id);
                                    },
                                  );
                                },
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesome.box,
                                      size: BUTTON_ICON_SIZE,
                                      color: getColorFromHex(COLOR_1),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  trxdc.detailItemsList[index].name,
                                  style: Get.textTheme.labelMedium,
                                ),
                                subtitle: Text(
                                  '${trxdc.detailItemsList[index].qty.toInt()} x ${moneyFormatter.format(trxdc.detailItemsList[index].price)}',
                                  style: Get.textTheme.labelSmall,
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      moneyFormatter.format(
                                        trxdc.detailItemsList[index].totalPrice,
                                      ),
                                      style: Get.textTheme.labelMedium,
                                    ),
                                    trxdc.detailItemsList[index].discount > 0.0
                                        ? Text(
                                            '(-${separatorFormatter.format(trxdc.detailItemsList[index].discount)})',
                                            style: Get.textTheme.labelSmall,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                ),
              ),
              const SizedBox(
                height: 20 * GOLDEN_RATIO,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: Get.textTheme.labelSmall?.copyWith(
                      fontSize: 9 * GOLDEN_RATIO,
                    ),
                  ),
                  Obx(
                    () => Text(
                      moneyFormatter.format(controller.subtotal.value),
                      style: Get.textTheme.labelSmall?.copyWith(
                        fontSize: 9 * GOLDEN_RATIO,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5 * GOLDEN_RATIO,
              ),
              Obx(
                () => ListTileSwitch(
                  contentPadding: const EdgeInsets.all(0),
                  switchActiveColor: getColorFromHex(COLOR_1),
                  title: Text(
                    'Make subtotal as final price',
                    style: Get.textTheme.labelMedium,
                  ),
                  subtitle: Text(
                    'When enabled, final price will be the same as subtotal',
                    style: Get.textTheme.labelSmall,
                  ),
                  value: controller.makeGrandTotalSameAsSubTotal.value,
                  onChanged: (val) {
                    controller.makeGrandTotalSameAsSubTotal.value = val;
                  },
                ),
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
              Obx(
                () => Visibility(
                  visible: controller.makeGrandTotalSameAsSubTotal.isFalse,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Grand Total',
                              style: Get.textTheme.labelSmall?.copyWith(
                                fontSize: 9 * GOLDEN_RATIO,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Form(
                              key: controller.formKey,
                              child: TextFormField(
                                controller: controller.grandTotalController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.end,
                                inputFormatters: [
                                  DecimalFormatter(
                                    maxVal: double.maxFinite,
                                  ),
                                ],
                                decoration: const InputDecoration(
                                  hintText: '0.0',
                                  prefix: Text('Rp '),
                                ),
                                validator: qtyAndPriceValidator,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10 * GOLDEN_RATIO,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => FilledButton.icon(
                  onPressed: controller.isLoading.isFalse
                      ? controller.askAddItemMethod
                      : null,
                  icon: controller.isLoading.isFalse
                      ? const Icon(
                          FontAwesome.plus,
                          size: BUTTON_ICON_SIZE,
                        )
                      : showCustomCircularProgressIndicator(),
                  label: controller.isLoading.isFalse
                      ? const Text('Add New Item')
                      : const Text('Saving...'),
                ),
              ),
              const SizedBox(
                height: 5 * GOLDEN_RATIO,
              ),
              Obx(
                () => OutlinedButton(
                  onPressed: controller.isLoading.isFalse
                      ? () async {
                          if (controller.detailItemsList.isEmpty) {
                            showErrorSnackbar('There is nothing to finalize');
                            return;
                          }
                          await showConfirmDialog(
                            context,
                            'Finalize items?\nYou can no longer edit items after you finalize.',
                            positiveText: 'Finalize',
                            negativeText: 'Cancel',
                            buttonColor: getColorFromHex(COLOR_1),
                            onAccept: controller.finalizeDetailItems,
                          );
                        }
                      : null,
                  child: controller.isLoading.isFalse
                      ? const Text('Finalize Item')
                      : const Text('Saving...'),
                ),
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
