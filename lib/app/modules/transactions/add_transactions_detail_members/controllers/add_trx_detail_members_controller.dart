import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/transaction_header_model.dart';
import '../../../../models/user_model.dart';
import '../../../../providers/friend_provider.dart';

class AddTrxDetailMembersController extends GetxController {
  final _friendRepo = FriendProvider();
  TransactionHeader trxHeader = Get.arguments as TransactionHeader;
  List<UserModel> unfilteredFL = [];
  RxList<UserModel> friendList = <UserModel>[].obs;
  RxList<UserModel> selectedFriend = <UserModel>[].obs;

  RxBool isFetching = false.obs;
  RxBool searchBarOpened = false.obs;

  final searchController = TextEditingController();

  void _toggleFetchingStatus(bool newStat) {
    isFetching.value = newStat;
    update();
  }

  void clearSearchFilter() {
    searchController.text = '';
    searchFriend();
    searchBarOpened.value = false;
  }

  void searchFriend() {
    _toggleFetchingStatus(true);

    friendList.value = unfilteredFL;

    if (searchController.text != '') {
      friendList.value = friendList
          .where(
            (friend) => friend.DisplayName.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }

    _toggleFetchingStatus(false);
  }

  Future<void> getFriendList() async {
    _toggleFetchingStatus(true);
    unfilteredFL = await _friendRepo.getFriendList();
    // unfilteredFL = [
    //   UserModel(Id: 'Test', DisplayName: 'Test', Email: 'test@test.com'),
    //   UserModel(Id: 'Test1', DisplayName: 'Test1', Email: 'test@test.com'),
    //   UserModel(Id: 'Test2', DisplayName: 'Test2', Email: 'test@test.com'),
    //   UserModel(Id: 'Test3', DisplayName: 'Test3', Email: 'test@test.com'),
    //   UserModel(Id: 'Test4', DisplayName: 'Test4', Email: 'test@test.com'),
    //   UserModel(Id: 'Test5', DisplayName: 'Test5', Email: 'test@test.com'),
    //   UserModel(Id: 'Test6', DisplayName: 'Test6', Email: 'test@test.com'),
    //   UserModel(Id: 'Test7', DisplayName: 'Test7', Email: 'test@test.com'),
    //   UserModel(Id: 'Test8', DisplayName: 'Test8', Email: 'test@test.com'),
    //   UserModel(Id: 'Test9', DisplayName: 'Test9', Email: 'test@test.com'),
    //   UserModel(Id: 'Test10', DisplayName: 'Test10', Email: 'test@test.com'),
    //   UserModel(Id: 'Test11', DisplayName: 'Test11', Email: 'test@test.com'),
    // ];
    friendList.value = unfilteredFL;
    _toggleFetchingStatus(false);
  }

  Future<void> finalizeMember() async {
    for (var i = 0; i < selectedFriend.length; i++) {
      print(selectedFriend[i].Id);
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await getFriendList();
  }
}
