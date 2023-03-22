import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:bill_splitter/app/widgets/friendBottomSheet/controllers/friend_bottom_sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriendBottomSheet extends GetView<FriendBottomSheetController> {
  const AddFriendBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 200 * GOLDEN_RATIO,
      width: Get.width,
      child: Row(children: [
        Text(
          'Add New Friends',
          style:
              Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextFormField()
      ]),
    );
  }
}
