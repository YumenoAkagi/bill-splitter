import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/validations_helper.dart';
import '../controllers/friend_bottom_sheet_controller.dart';

class FriendBottomSheetView extends StatelessWidget {
  FriendBottomSheetView({super.key});
  final controller = Get.put(FriendBottomSheetController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 15 * GOLDEN_RATIO, vertical: CONTAINER_MARGIN_VERTICAL),
      color: Colors.white,
      width: Get.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Friends',
              style: Get.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10 * GOLDEN_RATIO,
            ),
            Text(
              'Email Address',
              style: Get.textTheme.labelMedium,
            ),
            const SizedBox(
              height: 2 * GOLDEN_RATIO,
            ),
            TextFormField(
              controller: controller.friendEmailController,
              decoration:
                  const InputDecoration(hintText: 'Enter Email Address'),
              validator: emailValidator,
            ),
            const SizedBox(
              height: 30 * GOLDEN_RATIO,
            ),
            FilledButton(
                onPressed: () {
                  controller.addFriend();
                  Get.back();
                },
                child: const Text('Send Friend Request'))
          ],
        ),
      ),
    );
  }
}
