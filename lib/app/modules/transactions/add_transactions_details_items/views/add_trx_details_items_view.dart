import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
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
              Expanded(
                child: GetBuilder<AddTrxDetailsItemsController>(
                  builder: (trxdc) => trxdc.detailItemsList.isEmpty
                      ? Center(
                          child: Text(
                            'No items added',
                            style: Get.textTheme.labelSmall,
                          ),
                        )
                      : ListView.builder(
                          itemCount: trxdc.detailItemsList.length,
                          itemBuilder: (context, index) => ListTile(
                            onLongPress: () async {
                              await showConfirmDialog(
                                context,
                                'Delete selected item?',
                                negativeText: 'Cancel',
                                positiveText: 'Delete',
                                buttonColor: Colors.red,
                                onAccept: () async {
                                  await trxdc.removeItem(
                                      trxdc.detailItemsList[index].id);
                                },
                              );
                            },
                            title: Text(trxdc.detailItemsList[index].name),
                            subtitle: Text(
                              '${trxdc.detailItemsList[index].qty} x ${moneyFormatter.format(trxdc.detailItemsList[index].price)}',
                            ),
                            trailing: Text(
                              moneyFormatter.format(
                                  trxdc.detailItemsList[index].totalPrice),
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
              FilledButton.icon(
                onPressed: controller.askAddItemMethod,
                icon: const Icon(
                  FontAwesome.plus,
                  size: 10 * GOLDEN_RATIO,
                ),
                label: const Text('Add New Item'),
              ),
              const SizedBox(
                height: 5 * GOLDEN_RATIO,
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Finalize Item'),
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
