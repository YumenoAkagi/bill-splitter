import 'package:intl/intl.dart';

import '../models/transaction_header_model.dart';
import '../utils/app_constants.dart';
import '../utils/validations_helper.dart';
import 'package:get/get.dart';

class TransactionsProvider {
  Future<List<TransactionHeader>> getActiveTransactions() async {
    final List<TransactionHeader> headersList = [];
    try {
      final response = await supabaseClient
          .from('TransactionHeader')
          .select()
          .eq('CreatedById', supabaseClient.auth.currentUser?.id)
          .eq('IsComplete', false)
          .order(
            'created_at',
            ascending: false,
          );

      response.forEach((head) {
        headersList.add(
          TransactionHeader(
            id: head['Id'],
            name: head['Name'],
            date: DateFormat('dd MMM yyyy').format(
              DateTime.parse(
                head['Date'],
              ),
            ),
            grandTotal: head['GrandTotal'] ?? 0,
          ),
        );
      });
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
    return headersList;
  }
}
