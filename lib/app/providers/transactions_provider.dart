import 'package:bill_splitter/app/models/user_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/transaction_detail_item_model.dart';
import '../models/transaction_header_model.dart';
import '../utils/app_constants.dart';
import '../utils/validations_helper.dart';

class TransactionsProvider {
  Future<List<TransactionHeader>> getActiveTransactions() async {
    final List<TransactionHeader> headersList = [];
    try {
      final response = await supabaseClient
          .from('TransactionMember')
          .select('Users!inner(*), TransactionHeader!inner(*)')
          .eq('UserId', supabaseClient.auth.currentUser?.id)
          .eq('TransactionHeader.IsComplete', false)
          .order(
            'created_at',
            ascending: false,
          );

      response.forEach((head) {
        final existingHeader = headersList
            .firstWhereOrNull((e) => e.id == head['TransactionHeader']['Id']);
        if (existingHeader == null) {
          headersList.add(
            TransactionHeader(
              id: head['TransactionHeader']['Id'],
              name: head['TransactionHeader']['Name'],
              date: DateFormat('dd MMM yyyy').format(
                DateTime.parse(
                  head['TransactionHeader']['Date'],
                ),
              ),
              grandTotal: head['TransactionHeader']['GrandTotal'] ?? 0,
              isMemberFinalized:
                  head['TransactionHeader']['IsMemberFinalized'] ?? false,
              isItemFinalized:
                  head['TransactionHeader']['IsItemFinalized'] ?? false,
              isComplete: head['TransactionHeader']['IsComplete'] ?? false,
              isDeletable: head['TransactionHeader']['IsDeletetable'] ?? true,
              membersList: [
                UserModel(
                  Id: head['Users']['Id'],
                  DisplayName: head['Users']['DisplayName'],
                  Email: head['Users']['Email'],
                  ProfilePicUrl: head['Users']['ProfilePictureURL'],
                ),
              ],
            ),
          );
        } else {
          // add member to list
          existingHeader.membersList.add(
            UserModel(
              Id: head['Users']['Id'],
              DisplayName: head['Users']['DisplayName'],
              Email: head['Users']['Email'],
              ProfilePicUrl: head['Users']['ProfilePictureURL'],
            ),
          );
        }
      });
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
    return headersList;
  }

  Future<List<TransactionDetailItemModel>> fetchDetailsItems(
      String headerId) async {
    final List<TransactionDetailItemModel> itemsList = [];
    try {
      final response = await supabaseClient
          .from('TransactionDetail')
          .select()
          .eq('TransactionId', headerId);

      response.forEach((e) {
        itemsList.add(
          TransactionDetailItemModel(
            id: e['Id'],
            name: e['Name'],
            qty: e['Quantity'],
            price: e['Price'],
            totalPrice: e['Quantity'] * e['Price'],
          ),
        );
      });
    } catch (e) {
      if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
      Get.snackbar(unexpectedErrorText, e.toString());
    }
    return itemsList;
  }
}
