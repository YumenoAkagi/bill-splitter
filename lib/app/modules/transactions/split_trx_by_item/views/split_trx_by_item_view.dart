import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import '../../../../widgets/bs_assign_item_member/views/bs_assign_item_member_view.dart';
import '../controllers/split_trx_by_item_controller.dart';

class SplitTrxByItemView extends GetView<SplitTrxByItemController> {
  const SplitTrxByItemView({super.key});

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
                'Tap item to assign member',
                style: Get.textTheme.labelMedium,
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
              Expanded(
                child: GetBuilder<SplitTrxByItemController>(
                  builder: (stbic) => stbic.isFetching
                      ? showFetchingScreen()
                      : stbic.assignedItemMemberList.isEmpty
                          ? const Center(
                              child: Text('No Data'),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: stbic.assignedItemMemberList.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () async {
                                  stbic.selectedAssignItem =
                                      stbic.assignedItemMemberList[index];
                                  await Get.bottomSheet(
                                    const BsAssignItemMemberView(),
                                    isScrollControlled: true,
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 7 * GOLDEN_RATIO,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        stbic.assignedItemMemberList[index].item
                                            .name,
                                        style: Get.textTheme.labelMedium,
                                      ),
                                      const SizedBox(
                                        height: 3 * GOLDEN_RATIO,
                                      ),
                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              separatorFormatter.format(stbic
                                                  .assignedItemMemberList[index]
                                                  .item
                                                  .price),
                                              style: Get.textTheme.labelSmall,
                                            ),
                                            Text(
                                              '${stbic.assignedItemMemberList[index].item.qty.toInt()}x',
                                              style: Get.textTheme.labelSmall,
                                            ),
                                            Text(
                                              moneyFormatter.format(stbic
                                                  .assignedItemMemberList[index]
                                                  .item
                                                  .totalPrice),
                                              style: Get.textTheme.labelSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10 * GOLDEN_RATIO,
                                      ),
                                      (controller
                                                      .assignedItemMemberList[
                                                          index]
                                                      .assignedMembers
                                                      ?.length ??
                                                  0) <=
                                              0
                                          ? SizedBox(
                                              height: 20 * GOLDEN_RATIO,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    'No members assigned yet.',
                                                    style: Get
                                                        .textTheme.labelSmall
                                                        ?.copyWith(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(
                                              height: 20 * GOLDEN_RATIO,
                                              width: Get.width,
                                              child: WidgetStack(
                                                positions: RestrictedPositions(
                                                  align: StackAlign.left,
                                                  maxCoverage:
                                                      -0.75 * GOLDEN_RATIO,
                                                  minCoverage:
                                                      0.2 * GOLDEN_RATIO,
                                                ),
                                                stackedWidgets: [
                                                  for (var i = 0;
                                                      i <
                                                          (stbic
                                                                  .assignedItemMemberList[
                                                                      index]
                                                                  .assignedMembers
                                                                  ?.length ??
                                                              0);
                                                      i++)
                                                    CircularProfileAvatar(
                                                      stbic
                                                              .assignedItemMemberList[
                                                                  index]
                                                              .assignedMembers![
                                                                  i]
                                                              .profilePicUrl ??
                                                          '',
                                                      radius: 20 * GOLDEN_RATIO,
                                                      cacheImage: true,
                                                      backgroundColor:
                                                          getColorFromHex(
                                                              COLOR_1),
                                                      initialsText: Text(
                                                        stbic
                                                            .assignedItemMemberList[
                                                                index]
                                                            .assignedMembers![i]
                                                            .displayName[0],
                                                        style: Get.textTheme
                                                            .titleLarge
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
                                                    style: Get
                                                        .textTheme.titleLarge
                                                        ?.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                ),
              ),
              FilledButton(
                onPressed: controller.finalizeAndCalculate,
                child: const Text('Finalize and Calculate'),
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              )
            ],
          ),
        ),
      ),
    );
  }
}
