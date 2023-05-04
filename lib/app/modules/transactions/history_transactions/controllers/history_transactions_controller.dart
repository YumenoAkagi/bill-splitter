import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../models/transaction_header_model.dart';
import '../../../../providers/transactions_provider.dart';
import '../../../../utils/functions_helper.dart';

class HistoryTransactionsController extends GetxController {
  final transactionsRepo = TransactionsProvider();
  List<TransactionHeaderModel> historyTransactionsList = [];
  List<DateTime?> selectedDate = [];
  final dateFilterController = TextEditingController();

  bool isFetching = false;

  void _toggleFetchingStatus(bool newStat) {
    isFetching = newStat;
    update();
  }

  Future getHistoryTransactions() async {
    try {
      _toggleFetchingStatus(true);
      historyTransactionsList = await transactionsRepo.getTransactionHeaders(
        true,
        startDate: selectedDate[0],
        endDate: selectedDate[1],
      );
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    } finally {
      _toggleFetchingStatus(false);
    }
  }

  void setDateRange(List<DateTime?> selectedRange) async {
    selectedDate = selectedRange;
    dateFilterController.text =
        '${DateFormat('dd MMM yyyy').format(selectedDate[0] ?? DateTime.now().subtract(const Duration(days: 7)))} - ${DateFormat('dd MMM yyyy').format(selectedDate[1] ?? DateTime.now())}';
    await getHistoryTransactions();
  }

  void _initDateFilter() {
    selectedDate = [
      DateTime.now().subtract(const Duration(days: 7)),
      DateTime.now(),
    ];
    dateFilterController.text =
        '${DateFormat('dd MMM yyyy').format(selectedDate[0] ?? DateTime.now().subtract(const Duration(days: 7)))} - ${DateFormat('dd MMM yyyy').format(selectedDate[1] ?? DateTime.now())}';
  }

  @override
  void onInit() {
    super.onInit();
    _initDateFilter();
  }

  @override
  void onReady() async {
    super.onReady();
    await getHistoryTransactions();
  }
}
