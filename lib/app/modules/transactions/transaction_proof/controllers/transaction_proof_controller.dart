import 'package:bill_splitter/app/modules/transactions/transactions_detail/controllers/transaction_detail_controller.dart';

import '../../../../utils/app_constants.dart';

import '../../../../models/transaction_proof_model.dart';
import '../../../../providers/transactions_provider.dart';
import 'package:get/get.dart';

import '../../../../models/transaction_header_model.dart';

class TransactionProofController extends GetxController {
  final _transactionRepo = TransactionsProvider();
  TransactionHeaderModel trxHeader = Get.arguments as TransactionHeaderModel;

  List<TransactionProofModel> trxProofs = [];

  bool isFetching = false;

  void _toggleFetchingStatus(bool newStat) {
    isFetching = newStat;
    update();
  }

  Future confirmProof(int trxProofId) async {
    await _transactionRepo.verifyTransactionProof(trxProofId);
    try {
      final trxDetailController = Get.find<TransactionDetailController>();
      await trxDetailController.refreshNotValidatedCount();
    } catch (e) {
      // do nothing
    }
    await getTrxProof();
    update();
  }

  Future rejectProof(int trxProofId) async {
    await _transactionRepo.rejectTrxProof(trxProofId);
    try {
      final trxDetailController = Get.find<TransactionDetailController>();
      await trxDetailController.calculateRemainingDebtsReceivables();
      await trxDetailController.fetchTransactionUser();
    } catch (e) {
      // do nothing
    }
    await getTrxProof();
  }

  Future getTrxProof() async {
    _toggleFetchingStatus(true);

    trxProofs = await _transactionRepo.getUserTransactionProofs(
      trxHeader.id,
      supabaseClient.auth.currentUser!.id,
    );

    _toggleFetchingStatus(false);
  }

  @override
  void onInit() async {
    super.onInit();
    await getTrxProof();
  }
}
