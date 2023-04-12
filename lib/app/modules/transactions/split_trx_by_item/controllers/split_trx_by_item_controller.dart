import 'package:get/get.dart';

import '../../../../models/assigned_item_model.dart';
import '../../../../models/transaction_header_model.dart';
import '../../../../models/user_model.dart';
import '../../../../providers/transactions_provider.dart';
import '../../../../utils/functions_helper.dart';

class SplitTrxByItemController extends GetxController {
  TransactionHeader trxHeader = Get.arguments as TransactionHeader;
  final _transactionRepo = TransactionsProvider();
  List<AssignedItemModel> assignedItemMemberList = [];
  List<UserModel> memberList = [];

  AssignedItemModel? selectedAssignItem;

  bool isFetching = false;

  void _toggleFetchingStatus(bool newStat) {
    isFetching = newStat;
    update();
  }

  Future _getTransactionDetails() async {
    _toggleFetchingStatus(true);
    final itemList = await _transactionRepo.fetchDetailsItems(trxHeader.id);
    itemList.forEach((item) {
      assignedItemMemberList.add(AssignedItemModel(item: item));
    });
    _toggleFetchingStatus(false);
  }

  Future _getTransactionMembers() async {
    _toggleFetchingStatus(true);
    memberList = await _transactionRepo.getTransactionMembers(trxHeader.id);
    _toggleFetchingStatus(false);
  }

  Future finalizeAndCalculate() async {
    if (assignedItemMemberList
        .any((ai) => (ai.assignedMembers?.length ?? 0) <= 0)) {
      showErrorSnackbar('There are item(s) not yet assigned to any member.');
      return;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await _getTransactionDetails();
    await _getTransactionMembers();
  }
}
