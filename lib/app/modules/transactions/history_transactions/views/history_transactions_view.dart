import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:bill_splitter/app/routes/app_pages.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../controllers/history_transactions_controller.dart';

class HistoryTransactionsView extends GetView<HistoryTransactionsController> {
  const HistoryTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions History'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.getAllHistoryTransactions,
          child: GetBuilder<HistoryTransactionsController>(
            builder: (htc) => htc.isFetching
                ? showFetchingScreen()
                : htc.historyTransactionsList.isEmpty
                    ? const Center(
                        child: Text('No Data'),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: SAFEAREA_CONTAINER_MARGIN_H,
                          vertical: SAFEAREA_CONTAINER_MARGIN_V,
                        ),
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: htc.historyTransactionsList.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Get.toNamed(Routes.TRXDETAIL,
                                  arguments:
                                      htc.historyTransactionsList[index]);
                            },
                            child: Card(
                              elevation: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 20 * GOLDEN_RATIO,
                                    width: Get.width,
                                    child: WidgetStack(
                                      positions: RestrictedPositions(
                                        align: StackAlign.left,
                                        maxCoverage: -0.1 * GOLDEN_RATIO,
                                        minCoverage: 0.2 * GOLDEN_RATIO,
                                      ),
                                      stackedWidgets: [
                                        for (var i = 0;
                                            i <
                                                htc
                                                    .historyTransactionsList[
                                                        index]
                                                    .membersList
                                                    .length;
                                            i++)
                                          CircularProfileAvatar(
                                            htc
                                                    .historyTransactionsList[
                                                        index]
                                                    .membersList[i]
                                                    .profilePicUrl ??
                                                '',
                                            radius: 20 * GOLDEN_RATIO,
                                            cacheImage: true,
                                            backgroundColor:
                                                getColorFromHex(COLOR_1),
                                            initialsText: Text(
                                              htc
                                                  .historyTransactionsList[
                                                      index]
                                                  .membersList[i]
                                                  .displayName[0],
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
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      htc.historyTransactionsList[index].name,
                                      style: Get.textTheme.labelMedium,
                                    ),
                                    subtitle: Text(
                                      htc.historyTransactionsList[index].date,
                                      style: Get.textTheme.labelSmall,
                                    ),
                                    trailing: Column(
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
                                          moneyFormatter.format(htc
                                              .historyTransactionsList[index]
                                              .grandTotal),
                                          style: Get.textTheme.labelSmall
                                              ?.copyWith(
                                            fontSize: 12 * GOLDEN_RATIO,
                                          ),
                                        )
                                      ],
                                    ),
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
