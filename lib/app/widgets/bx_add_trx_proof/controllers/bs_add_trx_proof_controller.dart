import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../models/transaction_user_model.dart';
import '../../../modules/transactions/transactions_detail/controllers/transaction_detail_controller.dart';
import '../../../providers/transactions_provider.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/functions_helper.dart';

class BsAddTrxProofController extends GetxController {
  final _transactionRepo = TransactionsProvider();
  final _trxDetailController = Get.find<TransactionDetailController>();
  final formKey = GlobalKey<FormState>();
  final amountPaidController = TextEditingController();

  RxList<TransactionUserModel> trxUsersList = <TransactionUserModel>[].obs;
  TransactionUserModel? selectedTrxUser;
  RxDouble remainingAmount = 0.0.obs;
  RxBool isLoading = false.obs;

  void setSelectedRecipient(TransactionUserModel? newVal) {
    selectedTrxUser = newVal;
    remainingAmount.value = (newVal?.totalAmountOwed.toDouble() ?? 0.0) -
        (newVal?.amountPaid.toDouble() ?? 0.0);

    amountPaidController.text =
        separatorFormatter.format(remainingAmount.value);
  }

  Future _refreshDebts() async {
    trxUsersList.value = await _transactionRepo.getUserDebts(
      _trxDetailController.trxHeader.id,
      supabaseClient.auth.currentUser!.id,
    );
  }

  Future addTransactionProof() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    isLoading.value = false;
  }

  @override
  void onInit() async {
    super.onInit();
    await _refreshDebts();
  }
}
