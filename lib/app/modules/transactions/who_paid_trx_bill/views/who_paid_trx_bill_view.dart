import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../../../../widgets/bs_add_paid_bill_member/views/bs_add_paid_bill_member_view.dart';
import '../../../../widgets/bs_edit_paid_bill_member/views/bs_edit_paid_bill_view.dart';
import '../controllers/who_paid_trx_bill_controller.dart';

class WhoPaidTrxBillView extends GetView<WhoPaidTrxBillController> {
  const WhoPaidTrxBillView({super.key});

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
                'Member(s) who paid the bill',
                style: Get.textTheme.labelMedium,
              ),
              const SizedBox(
                height: 3 * GOLDEN_RATIO,
              ),
              Obx(
                () => Text(
                  'Remaining Amount\t\t\t\t\t: ${controller.remainingAmount.value == 0 ? '' : moneyFormatter.format(controller.remainingAmount.value)}',
                ),
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
              Expanded(
                child: GetBuilder<WhoPaidTrxBillController>(
                  builder: (wptb) => wptb.membersWhoPaidBill.isEmpty
                      ? Center(
                          child: Text(
                            'No data',
                            style: Get.textTheme.labelSmall,
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: wptb.membersWhoPaidBill.length,
                          itemBuilder: (context, index) => ListTile(
                            onTap: () async {
                              controller.selectedPayer =
                                  wptb.membersWhoPaidBill[index];
                              await Get.bottomSheet(
                                  const BsEditPaidMemberView());
                            },
                            onLongPress: () async {
                              await showConfirmDialog(
                                context,
                                'Delete selected payer?',
                                negativeText: 'Cancel',
                                positiveText: 'Delete',
                                buttonColor: Colors.red.shade700,
                                onAccept: () {
                                  wptb.removeMemberPaidBill(
                                      wptb.membersWhoPaidBill[index]);
                                },
                              );
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: CircularProfileAvatar(
                              wptb.membersWhoPaidBill[index].member
                                      .profilePicUrl ??
                                  '',
                              radius: 13 * GOLDEN_RATIO,
                              cacheImage: true,
                              backgroundColor: getColorFromHex(COLOR_1),
                              initialsText: Text(
                                wptb.membersWhoPaidBill[index].member
                                    .displayName[0],
                                style: Get.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              imageFit: BoxFit.cover,
                            ),
                            title: Text(
                              wptb.membersWhoPaidBill[index].member.displayName,
                              style: Get.textTheme.labelMedium,
                            ),
                            subtitle: Text(
                              wptb.membersWhoPaidBill[index].member.email,
                              style: Get.textTheme.labelSmall?.copyWith(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            trailing: Text(
                              moneyFormatter.format(
                                wptb.membersWhoPaidBill[index].paidAmount,
                              ),
                              style: Get.textTheme.labelSmall,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 20 * GOLDEN_RATIO,
              ),
              Obx(
                () => FilledButton.icon(
                  onPressed: controller.remainingAmount <= 0.0
                      ? null
                      : () async {
                          await Get.bottomSheet(
                            const BsAddPaidBillMemberView(),
                          );
                        },
                  icon: const Icon(
                    FontAwesome.plus,
                    size: 10 * GOLDEN_RATIO,
                  ),
                  label: const Text('Add Member'),
                ),
              ),
              const SizedBox(
                height: 5 * GOLDEN_RATIO,
              ),
              OutlinedButton(
                onPressed: controller.checkRemainingAmountAndNavigate,
                child: const Text('Continue'),
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
