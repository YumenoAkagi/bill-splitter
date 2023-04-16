import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../providers/friend_provider.dart';
import '../../home/controllers/friend_tab_controller.dart';
import '../../home/controllers/home_controller.dart';

class ManageFriendController extends GetxController {
  final friendProvider = FriendProvider();
  final homeController = Get.find<HomeController>();
  final friendTabController = Get.find<FriendTabController>();
  final friendEmailController = TextEditingController();
  List<UserModel> pendingFriendList = [];
  List<UserModel> requestFriendList = [];

  bool isFetching = false;

  void _toggleFetchingStatus(bool newStat) {
    isFetching = newStat;
    update();
  }

  Future getRequestFriendList() async {
    _toggleFetchingStatus(true);
    final requestFriendListFromRepo =
        await friendProvider.getRequestFriendList();
    requestFriendList = requestFriendListFromRepo;
    _toggleFetchingStatus(false);
  }

  Future getPendingFriendList() async {
    _toggleFetchingStatus(true);
    final pendingFriendListFromRepo =
        await friendProvider.getPendingFriendList();
    pendingFriendList = pendingFriendListFromRepo;
    _toggleFetchingStatus(false);
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
    friendTabController.getFriendList();
    homeController.recalcFriendRequest();
  }

  Future rejectRequest(UserModel userModel) async {
    await friendProvider.rejectRequest(userModel);
    requestFriendList.clear;
    getRequestFriendList();
    homeController.recalcFriendRequest();
  }

  @override
  void onInit() async {
    super.onInit();
    await getPendingFriendList();
    await getRequestFriendList();
  }
}
