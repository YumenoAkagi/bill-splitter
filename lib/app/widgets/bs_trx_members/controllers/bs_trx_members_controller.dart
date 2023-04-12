import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../modules/transactions/transactions_detail/controllers/transaction_detail_controller.dart';
import '../../../providers/transactions_provider.dart';

class BsTrxMembersController extends GetxController {
  final _transactionRepo = TransactionsProvider();
  final _trxDetailController = Get.find<TransactionDetailController>();
  List<UserModel> trxMembersList = [];
  RxBool isFetching = false.obs;

  void _toggleFetchingStatus(bool newStat) {
    isFetching.value = newStat;
    update();
  }

  Future getAllMembers() async {
    _toggleFetchingStatus(true);
    trxMembersList = await _transactionRepo
        .getTransactionMembers(_trxDetailController.trxHeader.id);
    _toggleFetchingStatus(false);
  }

  @override
  void onInit() async {
    super.onInit();
    await getAllMembers();
  }
}
