import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/validations_helper.dart';
import '../controllers/friend_bottom_sheet_controller.dart';

class FriendBottomSheetView extends StatelessWidget {
  FriendBottomSheetView({super.key});
  final controller = Get.put(FriendBottomSheetController());

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(
            horizontal: 10 * GOLDEN_RATIO,
            vertical: 20 * GOLDEN_RATIO,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add New Friends',
                  style: Get.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 12 * GOLDEN_RATIO,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 12 * GOLDEN_RATIO,
                ),
                Text(
                  'Email Address',
                  style: Get.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 3 * GOLDEN_RATIO,
                ),
                TextFormField(
                  controller: controller.friendEmailController,
                  decoration:
                      const InputDecoration(hintText: 'Enter Email Address'),
                  validator: emailValidator,
                ),
                const SizedBox(
                  height: 20 * GOLDEN_RATIO,
                ),
                Obx(
                  () => FilledButton(
                    onPressed: controller.isLoading.isFalse
                        ? controller.friendEmailController.text.isEmptyOrNull ? null : () {
                            controller.addFriend();
                            Get.back();
                          }
                        : null,
                    child: controller.isLoading.isFalse
                        ? const Text('Send Friend Request')
                        : const Text('Sending friend request...'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
