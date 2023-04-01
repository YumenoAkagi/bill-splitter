import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_constants.dart';
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
            builder: (htc) => htc.historyTransactionsList.isEmpty
                ? const Center(
                    child: Text('No Data'),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: SAFEAREA_CONTAINER_MARGIN_H,
                      vertical: SAFEAREA_CONTAINER_MARGIN_V,
                    ),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: htc.historyTransactionsList.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          htc.historyTransactionsList[index].name,
                          style: Get.textTheme.labelMedium,
                        ),
                        subtitle: Text(
                          htc.historyTransactionsList[index].date,
                          style: Get.textTheme.labelSmall,
                        ),
                        trailing: Column(
                          children: [
                            Text(
                              'Total',
                              style: Get.textTheme.labelMedium?.copyWith(
                                fontSize: 9 * GOLDEN_RATIO,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: 'id-ID', symbol: 'Rp')
                                  .format(htc.historyTransactionsList[index]
                                      .grandTotal),
                              style: Get.textTheme.labelSmall?.copyWith(
                                fontSize: 12 * GOLDEN_RATIO,
                              ),
                            )
                          ],
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
