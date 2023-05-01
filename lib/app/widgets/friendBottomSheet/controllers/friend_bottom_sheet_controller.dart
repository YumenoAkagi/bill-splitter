import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../modules/manage_friend/controllers/manage_friend_controller.dart';
import '../../../providers/friend_provider.dart';

class FriendBottomSheetController extends GetxController {
  final mfc = Get.find<ManageFriendController>();
  final friendEmailController = TextEditingController();
  final friendProvider = FriendProvider();

  RxBool isLoading = false.obs;
  RxBool canSubmit = false.obs;

  Future addFriend() async {
    isLoading.value = true;
    await friendProvider.addFriend(friendEmailController.text);
    mfc.getPendingFriendList();
    isLoading.value = false;
  }
}
