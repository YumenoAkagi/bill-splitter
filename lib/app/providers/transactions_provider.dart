import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/transaction_detail_item_model.dart';
import '../models/transaction_header_model.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';
import '../utils/functions_helper.dart';

class TransactionsProvider {
  Future<TransactionHeader?> getTransactionHeader(String headerId) async {
    final response = await supabaseClient
        .from('TransactionMember')
        .select('Users!inner(*)')
        .eq('TransactionId', headerId);

    List<UserModel> trxMembers = [];
    response.forEach((member) {
      trxMembers.add(
        UserModel(
          Id: member['Users']['Id'],
          DisplayName: member['Users']['DisplayName'],
          Email: member['Users']['Email'],
          ProfilePicUrl: member['Users']['ProfilePictureURL'],
        ),
      );
    });

    final headerFromResponse = await supabaseClient
        .from('TransactionHeader')
        .select()
        .eq('Id', headerId)
        .maybeSingle() as Map?;

    if (headerFromResponse == null) {
      showErrorSnackbar('Transaction not found');
      return null;
    }

    final selectedTrx = TransactionHeader(
      id: headerFromResponse['Id'],
      name: headerFromResponse['Name'],
      date: headerFromResponse['Date'],
      isComplete: headerFromResponse['IsComplete'],
      grandTotal: headerFromResponse['GrandTotal'],
      isDeletable: headerFromResponse['IsDeletable'],
      isItemFinalized: headerFromResponse['IsItemFinalized'],
      isMemberFinalized: headerFromResponse['IsMemberFinalized'],
      membersList: trxMembers,
    );

    return selectedTrx;
  }

  Future<List<TransactionHeader>> getTransactionHeaders(bool isComplete) async {
    final List<TransactionHeader> headersList = [];
    try {
      final response = await supabaseClient
          .from('TransactionMember')
          .select('Users!inner(*), TransactionHeader!inner(*)')
          .eq('UserId', supabaseClient.auth.currentUser?.id)
          .eq('TransactionHeader.IsComplete', isComplete)
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
      showUnexpectedErrorSnackbar(e);
    }
    return headersList;
  }

  Future<bool> deleteTransaction(String headerId) async {
    bool isDeleted = false;

    try {
      // delete header and its relations
      await supabaseClient
          .from('TransactionMember')
          .delete()
          .eq('TransactionId', headerId);
      await supabaseClient
          .from('TransactionDetail')
          .delete()
          .eq('TransactionId', headerId);
      await supabaseClient
          .from('TransactionHeader')
          .delete()
          .eq('Id', headerId);
      showSuccessSnackbar('Success', 'Transaction successfully deleted');
      isDeleted = true;
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
    return isDeleted;
  }

  Future<List<TransactionDetailItemModel>> fetchDetailsItems(
      String headerId) async {
    final List<TransactionDetailItemModel> itemsList = [];
    try {
      final response = await supabaseClient
          .from('TransactionDetail')
          .select()
          .eq('TransactionId', headerId);

      response.forEach((item) {
        final newTrx = TransactionDetailItemModel(
          id: item['Id'],
          transactionId: item['TransactionId'],
          name: item['Name'],
          qty: item['Quantity'],
          price: item['Price'],
          totalPrice: item['TotalPrice'],
        );
        itemsList.add(
          newTrx,
        );
      });
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
    return itemsList;
  }

  Future<bool> finalizeDetailItem(String headerId, num grandTotal) async {
    bool isResponseFinalized = false;

    try {
      await supabaseClient.from('TransactionHeader').update({
        'IsItemFinalized': true,
        'GrandTotal': grandTotal,
      }).eq('Id', headerId);
      isResponseFinalized = true;
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }

    return isResponseFinalized;
  }
}
