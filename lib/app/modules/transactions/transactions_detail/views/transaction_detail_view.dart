import '../../../../routes/app_pages.dart';
import '../../../../widgets/bx_add_trx_proof/views/bs_add_trx_proof_view.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:badges/badges.dart' as badges;

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../../../../widgets/bs_trx_members/views/bs_trx_members_view.dart';
import '../controllers/transaction_detail_controller.dart';

class TransactionDetailView extends GetView<TransactionDetailController> {
  const TransactionDetailView({super.key});

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
                'Transaction Date:\t${controller.trxHeader.date}',
                style: Get.textTheme.labelSmall,
              ),
              const SizedBox(
                height: 6 * GOLDEN_RATIO,
              ),
              Text(
                'Your Statistics',
                style: Get.textTheme.labelMedium,
              ),
              const SizedBox(
                height: 8 * GOLDEN_RATIO,
              ),
              Table(
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Text(
                          'Remaining Debts\t:',
                          style: Get.textTheme.labelSmall?.copyWith(
                            fontSize: 8 * GOLDEN_RATIO,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          'Remaining Receivables\t:',
                          style: Get.textTheme.labelSmall?.copyWith(
                            fontSize: 8 * GOLDEN_RATIO,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Obx(
                          () => Text(
                            controller.totalDebts.value <= 0
                                ? '-'
                                : moneyFormatter
                                    .format(controller.totalDebts.value),
                            style: Get.textTheme.labelMedium?.copyWith(
                              color: Colors.red.shade700,
                              fontSize: 11 * GOLDEN_RATIO,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Obx(
                          () => Text(
                            controller.totalReceivables.value <= 0
                                ? '-'
                                : moneyFormatter
                                    .format(controller.totalReceivables.value),
                            style: Get.textTheme.labelMedium?.copyWith(
                              fontSize: 11 * GOLDEN_RATIO,
                              color: getColorFromHex(COLOR_5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
              Text(
                'Details',
                style: Get.textTheme.labelMedium?.copyWith(
                  fontSize: 9 * GOLDEN_RATIO,
                ),
              ),
              const SizedBox(
                height: 8 * GOLDEN_RATIO,
              ),
              Expanded(
                child: GetBuilder<TransactionDetailController>(
                  id: controller.transactionUserId,
                  builder: (tdc) => tdc.isFetchingUser.isTrue
                      ? showFetchingScreen()
                      : tdc.trxMembers.isEmpty
                          ? const Center(
                              child: Text('No data'),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: controller.trxMembers.length,
                              itemBuilder: (context, index) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircularProfileAvatar(
                                  tdc.trxMembers[index].toUser.id ==
                                          supabaseClient.auth.currentUser!.id
                                      ? tdc.trxMembers[index].fromUser
                                              .profilePicUrl ??
                                          ''
                                      : tdc.trxMembers[index].toUser
                                              .profilePicUrl ??
                                          '',
                                  radius: 13 * GOLDEN_RATIO,
                                  cacheImage: true,
                                  backgroundColor: getColorFromHex(COLOR_1),
                                  initialsText: Text(
                                    tdc.trxMembers[index].toUser.id ==
                                            supabaseClient.auth.currentUser!.id
                                        ? tdc.trxMembers[index].fromUser
                                            .displayName[0]
                                        : tdc.trxMembers[index].toUser
                                            .displayName[0],
                                    style: Get.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  imageFit: BoxFit.cover,
                                ),
                                title: Text(
                                  tdc.trxMembers[index].toUser.id ==
                                          supabaseClient.auth.currentUser!.id
                                      ? tdc.trxMembers[index].fromUser
                                          .displayName
                                      : tdc
                                          .trxMembers[index].toUser.displayName,
                                  style: Get.textTheme.labelMedium?.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                subtitle: Text(
                                  tdc.trxMembers[index].toUser.id ==
                                          supabaseClient.auth.currentUser!.id
                                      ? tdc.trxMembers[index].fromUser.email
                                      : tdc.trxMembers[index].toUser.email,
                                  style: Get.textTheme.titleSmall?.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      moneyFormatter.format(tdc
                                              .trxMembers[index]
                                              .totalAmountOwed -
                                          tdc.trxMembers[index].amountPaid),
                                      style:
                                          Get.textTheme.labelMedium?.copyWith(
                                        color:
                                            tdc.trxMembers[index].toUser.id ==
                                                    supabaseClient
                                                        .auth.currentUser!.id
                                                ? getColorFromHex(COLOR_5)
                                                : Colors.red.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                ),
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
              OutlinedButton(
                onPressed: () async {
                  await Get.bottomSheet(
                    const BsTrxMembersView(),
                    isScrollControlled: true,
                  );
                },
                child: const Text('View Transaction Members'),
              ),
              const Divider(
                thickness: 1 * GOLDEN_RATIO,
                height: 25 * GOLDEN_RATIO,
              ),
              Text(
                'Items List',
                style: Get.textTheme.labelMedium,
              ),
              const SizedBox(
                height: 8 * GOLDEN_RATIO,
              ),
              SizedBox(
                height: Get.height * 0.15 * GOLDEN_RATIO,
                child: Column(
                  children: [
                    Expanded(
                      child: GetBuilder<TransactionDetailController>(
                        id: controller.transactionDetailId,
                        builder: (tdc) => tdc.isFetchingDetail.isTrue
                            ? showFetchingScreen()
                            : tdc.trxItems.isEmpty
                                ? const Center(
                                    child: Text('No data'),
                                  )
                                : SingleChildScrollView(
                                    child: Table(
                                      columnWidths: <int, TableColumnWidth>{
                                        0: FixedColumnWidth(
                                            Get.width * 0.1 * GOLDEN_RATIO),
                                        1: const IntrinsicColumnWidth(),
                                        2: const FlexColumnWidth()
                                      },
                                      children: controller.trxItems
                                          .map(
                                            (item) => TableRow(
                                              children: [
                                                TableCell(
                                                  child: SizedBox(
                                                    height: 14 * GOLDEN_RATIO,
                                                    child: Text(
                                                      '${item.qty.toInt()}x',
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: SizedBox(
                                                    height: 14 * GOLDEN_RATIO,
                                                    child: Text(
                                                      item.name,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: SizedBox(
                                                    height: 14 * GOLDEN_RATIO,
                                                    child: Text(
                                                      moneyFormatter.format(
                                                          item.totalPrice),
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal:',
                          style: Get.textTheme.labelSmall,
                        ),
                        Obx(
                          () => Text(
                            moneyFormatter.format(controller.subtotal.value),
                            style: Get.textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2 * GOLDEN_RATIO,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Final Price:',
                          style: Get.textTheme.labelMedium,
                        ),
                        Text(
                          moneyFormatter
                              .format(controller.trxHeader.grandTotal),
                          style: Get.textTheme.labelMedium,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15 * GOLDEN_RATIO,
                    ),
                    Obx(
                      () => controller.hasDebts.isTrue
                          ? controller.totalDebts.value > 0.0
                              ? FilledButton(
                                  onPressed: () async {
                                    await Get.bottomSheet(
                                      const BsAddTrxProofView(),
                                    );
                                  },
                                  child: const Text('I Have Paid My Bills'),
                                )
                              : FilledButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.TRXPROOFS,
                                        arguments: controller.trxHeader);
                                  },
                                  child: const Text(
                                      'View My Payment Confirmation'),
                                )
                          : controller.remainingNotValidatedProof.value > 0
                              ? badges.Badge(
                                  badgeContent: Text(
                                    controller.remainingNotValidatedProof.value
                                        .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  position:
                                      badges.BadgePosition.topEnd(end: -4),
                                  child: FilledButton(
                                    onPressed: () {
                                      Get.toNamed(Routes.TRXPROOFS,
                                          arguments: controller.trxHeader);
                                    },
                                    child:
                                        const Text('View Transaction Proofs'),
                                  ),
                                )
                              : FilledButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.TRXPROOFS,
                                        arguments: controller.trxHeader);
                                  },
                                  child: const Text('View Transaction Proofs'),
                                ),
                    ),
                  ],
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
