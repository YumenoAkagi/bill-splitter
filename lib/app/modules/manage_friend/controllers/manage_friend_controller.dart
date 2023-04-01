import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../providers/friend_provider.dart';
import '../../home/controllers/friend_tab_controller.dart';
import '../../home/controllers/home_controller.dart';

class ManageFriendController extends GetxController {
  final friendProvider = FriendProvider();
  final homeController = Get.find<HomeController>();
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

  Future acceptRequest(UserModel userModel) async {
    await friendProvider.acceptRequest(userModel);
    requestFriendList.clear();
    getRequestFriendList();
    var ftc = Get.find<FriendTabController>();
    ftc.getFriendList();
    homeController.recalcFriendRequest();
  }

  Future rejectRequest(UserModel userModel) async {
    await friendProvider.rejectRequest(userModel);
    requestFriendList.clear;
    getRequestFriendList();
  }

  @override
  void onInit() async {
    super.onInit();
    await getPendingFriendList();
    await getRequestFriendList();
  }
}
