import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../controllers/transaction_proof_controller.dart';

class TransactionProofView extends GetView<TransactionProofController> {
  const TransactionProofView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Confirmations'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: SAFEAREA_CONTAINER_MARGIN_H,
            vertical: SAFEAREA_CONTAINER_MARGIN_V,
          ),
          child: GetBuilder<TransactionProofController>(
            builder: (tpc) => tpc.isFetching
                ? showFetchingScreen()
                : tpc.trxProofs.isEmpty
                    ? const Center(
                        child: Text('No data'),
                      )
                    : ListView.separated(
                        itemCount: tpc.trxProofs.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text.rich(
                                TextSpan(
                                  style: Get.textTheme.labelMedium,
                                  children: [
                                    TextSpan(
                                      text: tpc.trxProofs[index].fromUser.id ==
                                              supabaseClient
                                                  .auth.currentUser!.id
                                          ? 'You'
                                          : tpc.trxProofs[index].fromUser
                                              .displayName,
                                      style:
                                          Get.textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const TextSpan(text: ' paid '),
                                    TextSpan(
                                      text:
                                          '${moneyFormatter.format(tpc.trxProofs[index].paidAmount)} ',
                                      style:
                                          Get.textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const TextSpan(text: 'to '),
                                    TextSpan(
                                      text: tpc.trxProofs[index].fromUser.id ==
                                              supabaseClient
                                                  .auth.currentUser!.id
                                          ? tpc.trxProofs[index].toUser
                                              .displayName
                                          : 'You',
                                      style:
                                          Get.textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(tpc.trxProofs[index].createdDate),
                                  Text(
                                    tpc.trxProofs[index].isVerified
                                        ? 'Verified at ${tpc.trxProofs[index].verifiedAt}'
                                        : 'Not yet confirmed',
                                  ),
                                ],
                              ),
                              leading: tpc.trxProofs[index].fromUser.id ==
                                      supabaseClient.auth.currentUser!.id
                                  ? const Icon(
                                      FontAwesome.up_circled,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      FontAwesome.down_circled,
                                      color: getColorFromHex(COLOR_5),
                                    ),
                              trailing: tpc.trxProofs[index].imgUrl == null
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 50 * GOLDEN_RATIO,
                                      width: 50 * GOLDEN_RATIO,
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(
                                            Routes.SHOWIMAGE,
                                            arguments: tpc.trxProofs[index],
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                BUTTON_BORDER_RAD),
                                            border: Border.all(
                                              color: getColorFromHex(COLOR_1),
                                              width: 0.75,
                                            ),
                                          ),
                                          child: Hero(
                                            tag: tpc.trxProofs[index].id,
                                            child: Image.network(
                                              tpc.trxProofs[index].imgUrl!,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            if (supabaseClient.auth.currentUser!.id ==
                                    tpc.trxProofs[index].toUser.id &&
                                !tpc.trxProofs[index].isVerified)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(
                                    height: 5 * GOLDEN_RATIO,
                                  ),
                                  Text(
                                    'Confirm this payment?',
                                    style: Get.textTheme.labelMedium,
                                  ),
                                  const SizedBox(
                                    height: 5 * GOLDEN_RATIO,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () async {
                                              await showConfirmDialog(
                                                context,
                                                'Reject this payment?',
                                                positiveText: 'Reject',
                                                negativeText: 'Cancel',
                                                buttonColor:
                                                    Colors.red.shade700,
                                                onAccept: () async {
                                                  controller.rejectProof(
                                                    tpc.trxProofs[index].id,
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              FontAwesome.cancel,
                                              size: BUTTON_ICON_SIZE,
                                            ),
                                            label: const Text('Reject'),
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red.shade700),
                                              side: MaterialStateProperty.all(
                                                BorderSide(
                                                  color: Colors.red.shade700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5 * GOLDEN_RATIO,
                                        ),
                                        Expanded(
                                          child: FilledButton.icon(
                                            onPressed: () async {
                                              await showConfirmDialog(
                                                context,
                                                'Confirm this payment?',
                                                positiveText: 'Confirm',
                                                negativeText: 'Cancel',
                                                buttonColor:
                                                    getColorFromHex(COLOR_1),
                                                onAccept: () async {
                                                  controller.confirmProof(
                                                    tpc.trxProofs[index].id,
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              FontAwesome.check,
                                              size: BUTTON_ICON_SIZE,
                                            ),
                                            label: const Text('Confirm'),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                getColorFromHex(COLOR_1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
