import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../providers/friend_provider.dart';

class FriendBottomSheetController extends GetxController {
  final friendEmailController = TextEditingController();
  final friendProvider = FriendProvider();
  Future addFriend() async {
    friendProvider.addFriend(friendEmailController.text);
  }
}
