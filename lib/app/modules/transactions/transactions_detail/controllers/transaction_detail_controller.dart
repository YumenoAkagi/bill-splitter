import 'package:get/get.dart';

import '../../../../models/transaction_detail_item_model.dart';
import '../../../../models/transaction_header_model.dart';
import '../../../../models/transaction_user_model.dart';
import '../../../../providers/transactions_provider.dart';
import '../../../../utils/app_constants.dart';

class TransactionDetailController extends GetxController {
  TransactionHeaderModel trxHeader = Get.arguments as TransactionHeaderModel;
  final transactionUserId = 'transaction-user';
  final transactionDetailId = 'transaction-detail';
  final _transactionRepo = TransactionsProvider();

  List<TransactionDetailItemModel> trxItems = [];
  List<TransactionUserModel> trxMembers = [];

  RxDouble totalDebts = 0.0.obs;
  RxDouble totalReceivables = 0.0.obs;
  RxDouble subtotal = 0.0.obs;

  RxBool isFetchingUser = false.obs;
  RxBool isFetchingDetail = false.obs;
  RxBool hasDebts = false.obs;
  RxBool hasReceivables = false.obs;

  void _toggleFetchingStatusUser(bool newStat) {
    isFetchingUser.value = newStat;
    update([transactionUserId]);
  }

  void _toggleFetchingStatusDetail(bool newStat) {
    isFetchingDetail.value = newStat;
    update([transactionDetailId]);
  }

  Future calculateRemainingDebtsReceivables() async {
    totalDebts.value = await _transactionRepo.getTotalDebtsForCurrentUser(
        supabaseClient.auth.currentUser!.id, trxHeader.id);

    totalReceivables.value =
        await _transactionRepo.getTotalReceivablesForCurrentUser(
            supabaseClient.auth.currentUser!.id, trxHeader.id);
  }

  Future fetchTransactionUser() async {
    _toggleFetchingStatusUser(true);
    trxMembers = await _transactionRepo.getTransactionUsers(
        trxHeader.id, supabaseClient.auth.currentUser!.id);
    if (trxMembers
        .any((tu) => tu.toUser.id == supabaseClient.auth.currentUser!.id)) {
      hasReceivables.value = true;
    }
    if (trxMembers
        .any((tu) => tu.fromUser.id == supabaseClient.auth.currentUser!.id)) {
      hasDebts.value = true;
    }
    _toggleFetchingStatusUser(false);
  }

  Future fetchTransactionDetail() async {
    _toggleFetchingStatusDetail(true);
    trxItems = await _transactionRepo.fetchDetailsItems(trxHeader.id);
    subtotal.value = trxItems.fold(0.0, (prev, item) => prev + item.totalPrice);
    _toggleFetchingStatusDetail(false);
  }

  @override
  void onReady() async {
    super.onReady();
    await calculateRemainingDebtsReceivables();
    await fetchTransactionUser();
    await fetchTransactionDetail();
  }
}
