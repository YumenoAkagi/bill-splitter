import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';
import '../controllers/bs_assign_item_member.controller.dart';

class BsAssignItemMemberView extends StatelessWidget {
  const BsAssignItemMemberView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      BsAssignItemMemberController(),
    );
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15 * GOLDEN_RATIO),
              topRight: Radius.circular(15 * GOLDEN_RATIO),
            ),
            color: Get.isDarkMode
                ? getColorFromHex(COLOR_DARK_MAIN)
                : Colors.white,
          ),
          width: Get.width,
          height: Get.height * 0.55 * GOLDEN_RATIO,
          padding: const EdgeInsets.only(
            right: 10 * GOLDEN_RATIO,
            left: 10 * GOLDEN_RATIO,
            bottom: 20 * GOLDEN_RATIO,
            top: 5 * GOLDEN_RATIO,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              showCustomHandleBar(),
              Text(
                controller
                    .splitTrxByItemController.selectedAssignItem!.item.name,
                style: Get.textTheme.labelMedium,
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      separatorFormatter.format(controller
                          .splitTrxByItemController
                          .selectedAssignItem!
                          .item
                          .price),
                      style: Get.textTheme.labelSmall,
                    ),
                    Text(
                      '${controller.splitTrxByItemController.selectedAssignItem!.item.qty.toInt()}x',
                      style: Get.textTheme.labelSmall,
                    ),
                    Text(
                      moneyFormatter.format(controller.splitTrxByItemController
                          .selectedAssignItem!.item.totalPrice),
                      style: Get.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20 * GOLDEN_RATIO,
              ),
              Text(
                'Select Members',
                style: Get.textTheme.labelMedium,
              ),
              const SizedBox(
                height: 10 * GOLDEN_RATIO,
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: controller.memberList.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    controller.selectedMember
                            .contains(controller.memberList[index])
                        ? controller.selectedMember
                            .remove(controller.memberList[index])
                        : controller.selectedMember
                            .add(controller.memberList[index]);
                  },
                  borderRadius: BorderRadius.circular(8 * GOLDEN_RATIO),
                  child: Obx(
                    () => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        controller.memberList[index].displayName,
                      ),
                      subtitle: Text(
                        controller.memberList[index].email,
                      ),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: controller.selectedMember.contains(
                              controller.memberList[index],
                            ),
                            onChanged: null,
                          ),
                          CircularProfileAvatar(
                            controller.memberList[index].profilePicUrl ?? '',
                            radius: 15 * GOLDEN_RATIO,
                            cacheImage: true,
                            backgroundColor: getColorFromHex(COLOR_1),
                            initialsText: Text(
                              controller.memberList[index].displayName[0],
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            imageFit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ],
    );
  }
}
