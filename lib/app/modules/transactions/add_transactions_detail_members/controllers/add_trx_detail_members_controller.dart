import 'package:bill_splitter/app/providers/transactions_provider.dart';

import '../../../home/controllers/transactions_tab_controller.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/functions_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/transaction_header_model.dart';
import '../../../../models/user_model.dart';
import '../../../../providers/friend_provider.dart';

class AddTrxDetailMembersController extends GetxController {
  final _friendRepo = FriendProvider();
  final _transactionRepo = TransactionsProvider();
  TransactionHeader trxHeader = Get.arguments as TransactionHeader;
  List<UserModel> unfilteredFL = [];
  RxList<UserModel> friendList = <UserModel>[].obs;
  RxList<UserModel> selectedFriend = <UserModel>[].obs;

  RxBool isFetching = false.obs;
  RxBool isLoading = false.obs;
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
            (friend) => friend.displayName.toLowerCase().contains(
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
    friendList.value = unfilteredFL;
    _toggleFetchingStatus(false);
  }

  Future<void> finalizeMember() async {
    if (selectedFriend.isEmpty) {
      showErrorSnackbar('Please select at least one member');
      return;
    }

    isLoading.value = true;

    final isFinalized = await _transactionRepo.finalizeDetailMember(
        trxHeader.id, selectedFriend);

    if (isFinalized) {
      trxHeader.isMemberFinalized = true;
      trxHeader.membersList.addAll(selectedFriend);
      try {
        final transactionTabController = Get.find<TransactionsTabController>();
        await transactionTabController.getActiveTransactions();
      } catch (e) {
        // do nothing
      }
      isLoading.value = false;
      Get.offNamed(Routes.TRXSPLITOPTIONS, arguments: trxHeader);
    } else {
      isLoading.value = false;
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await getFriendList();
  }
}
