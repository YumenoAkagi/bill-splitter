import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../providers/friend_provider.dart';

class ManageFriendController extends GetxController {
  final friendProvider = FriendProvider();
  List<UserModel> pendingFriendList = [];
  List<UserModel> requestFriendList = [];
  final friendEmailController = TextEditingController();

  Future getRequestFriendList() async {
    final requestFriendListFromRepo =
        await friendProvider.getRequestFriendList();
    requestFriendList = requestFriendListFromRepo;
    update();
  }

  Future getPendingFriendList() async {
    final pendingFriendListFromRepo =
        await friendProvider.getPendingFriendList();
    pendingFriendList = pendingFriendListFromRepo;
    update();
  }

  Future deletePendingRequest(UserModel userModel) async {
    await friendProvider.deletePendingFriend(userModel);
    pendingFriendList.clear();
    getPendingFriendList();
  }

  @override
  void onInit() async {
    super.onInit();
    await getPendingFriendList();
    await getRequestFriendList();
  }
}
