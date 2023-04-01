import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/transactions_tab_controller.dart';

class TransactionsTabView extends StatelessWidget {
  const TransactionsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionsTabController());
    return RefreshIndicator(
      onRefresh: controller.getActiveTransactions,
      child: GetBuilder<TransactionsTabController>(
        builder: (ttc) => ttc.headersList.isEmpty
            ? const Center(
                child: Text('No data'),
              )
            : Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: SAFEAREA_CONTAINER_MARGIN_H,
                  vertical: SAFEAREA_CONTAINER_MARGIN_V,
                ),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: ttc.headersList.length,
                  itemBuilder: (context, index) => Dismissible(
                    key: ValueKey(ttc.headersList[index].id),
                    onDismissed: (_) async {
                      await controller
                          .deleteTransaction(ttc.headersList[index].id);
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.only(right: 10 * GOLDEN_RATIO),
                      color: Colors.red,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Entypo.trash,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    confirmDismiss: (_) async {
                      bool confirmDelete = false;

                      await showConfirmDialog(
                        context,
                        'Delete this transaction?\nThis action cannot be undone.',
                        buttonColor: Colors.red,
                        negativeText: 'Cancel',
                        positiveText: 'Delete',
                        onAccept: () {
                          confirmDelete = true;
                        },
                      );

                      return confirmDelete;
                    },
                    child: InkWell(
                      onTap: () =>
                          controller.viewTrxDetail(ttc.headersList[index].id),
                      borderRadius: BorderRadius.circular(8 * GOLDEN_RATIO),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8 * GOLDEN_RATIO),
                        ),
                        elevation: 2,
                        child: Container(
                          margin: const EdgeInsets.all(
                            5 * GOLDEN_RATIO,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                ttc.headersList[index].name,
                                style: Get.textTheme.labelMedium,
                              ),
                              Text(
                                ttc.headersList[index].date,
                                style: Get.textTheme.labelSmall,
                              ),
                              const SizedBox(
                                height: 5 * GOLDEN_RATIO,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircularProfileAvatar(
                                    'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                                    imageFit: BoxFit.cover,
                                    radius: 10 * GOLDEN_RATIO,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Total',
                                        style:
                                            Get.textTheme.labelMedium?.copyWith(
                                          fontSize: 9 * GOLDEN_RATIO,
                                        ),
                                      ),
                                      Text(
                                        NumberFormat.currency(
                                                locale: 'id-ID', symbol: 'Rp')
                                            .format(ttc
                                                .headersList[index].grandTotal),
                                        style:
                                            Get.textTheme.labelSmall?.copyWith(
                                          fontSize: 12 * GOLDEN_RATIO,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
