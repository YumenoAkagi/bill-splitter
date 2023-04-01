import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';
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
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: Get.height * 0.5 * GOLDEN_RATIO,
                  child: const Center(
                    child: Text('No data'),
                  ),
                ),
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
                    key: UniqueKey(),
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
                      if (!ttc.headersList[index].isDeletable) {
                        if (Get.isSnackbarOpen) {
                          await Get.closeCurrentSnackbar();
                        }
                        Get.snackbar('Permission Denied',
                            'This transaction has been partially paid by you/other members');
                        return false;
                      }
                      bool confirmDelete = false;

                      await showConfirmDialog(
                        context,
                        'Delete ${ttc.headersList[index].name}?\nThis action cannot be undone.',
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
                                  SizedBox(
                                    height: 20 * GOLDEN_RATIO,
                                    width: Get.width * 0.3 * GOLDEN_RATIO,
                                    child: WidgetStack(
                                      positions: RestrictedPositions(
                                        align: StackAlign.left,
                                        maxCoverage: -0.1,
                                        minCoverage: -0.5,
                                      ),
                                      stackedWidgets: [
                                        for (var i = 0;
                                            i <
                                                ttc.headersList[index]
                                                    .membersList.length;
                                            i++)
                                          CircularProfileAvatar(
                                            ttc
                                                    .headersList[index]
                                                    .membersList[i]
                                                    .ProfilePicUrl ??
                                                '',
                                            radius: 20 * GOLDEN_RATIO,
                                            cacheImage: true,
                                            backgroundColor:
                                                getColorFromHex(COLOR_1),
                                            initialsText: Text(
                                              ttc
                                                  .headersList[index]
                                                  .membersList[i]
                                                  .DisplayName[0],
                                              style: Get.textTheme.titleLarge
                                                  ?.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                            imageFit: BoxFit.cover,
                                          ),
                                      ],
                                      buildInfoWidget: (surplus) =>
                                          CircularProfileAvatar(
                                        '',
                                        radius: 20 * GOLDEN_RATIO,
                                        backgroundColor:
                                            getColorFromHex(COLOR_1),
                                        initialsText: Text(
                                          '+$surplus',
                                          style: Get.textTheme.titleLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Total',
                                          style: Get.textTheme.labelMedium
                                              ?.copyWith(
                                            fontSize: 9 * GOLDEN_RATIO,
                                          ),
                                        ),
                                        Text(
                                          moneyFormatter.format(ttc
                                              .headersList[index].grandTotal),
                                          style: Get.textTheme.labelSmall
                                              ?.copyWith(
                                            fontSize: 12 * GOLDEN_RATIO,
                                          ),
                                        ),
                                      ],
                                    ),
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
