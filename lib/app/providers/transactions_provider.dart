import 'package:bill_splitter/app/models/trx_member_pays_the_bill.dart';
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
          id: member['Users']['Id'],
          displayName: member['Users']['DisplayName'],
          email: member['Users']['Email'],
          profilePicUrl: member['Users']['ProfilePictureURL'],
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
          ) as List;

      for (var idx = 0; idx < response.length; idx++) {
        final allTrxMembers = <UserModel>[
          UserModel(
            id: response[idx]['Users']['Id'],
            displayName: response[idx]['Users']['DisplayName'],
            email: response[idx]['Users']['Email'],
            profilePicUrl: response[idx]['Users']['ProfilePictureURL'],
          ),
        ];
        final otherMemberResponse = await supabaseClient
            .from('TransactionMember')
            .select('Users!inner(*)')
            .eq('TransactionId', response[idx]['TransactionHeader']['Id']);
        otherMemberResponse.forEach((mem) {
          if (mem['Users']['Id'] !=
              (supabaseClient.auth.currentUser?.id ?? '')) {
            allTrxMembers.add(UserModel(
              id: mem['Users']['Id'],
              displayName: mem['Users']['DisplayName'],
              email: mem['Users']['Email'],
              profilePicUrl: mem['Users']['ProfilePictureURL'],
            ));
          }
        });

        headersList.add(
          TransactionHeader(
            id: response[idx]['TransactionHeader']['Id'],
            name: response[idx]['TransactionHeader']['Name'],
            date: DateFormat('dd MMM yyyy').format(
              DateTime.parse(
                response[idx]['TransactionHeader']['Date'],
              ),
            ),
            grandTotal: response[idx]['TransactionHeader']['GrandTotal'] ?? 0,
            isMemberFinalized: response[idx]['TransactionHeader']
                    ['IsMemberFinalized'] ??
                false,
            isItemFinalized:
                response[idx]['TransactionHeader']['IsItemFinalized'] ?? false,
            isComplete:
                response[idx]['TransactionHeader']['IsComplete'] ?? false,
            isDeletable:
                response[idx]['TransactionHeader']['IsDeletetable'] ?? true,
            membersList: allTrxMembers,
          ),
        );
      }
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
          .from('TransactionUser')
          .delete()
          .eq('TransactionId', headerId);
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

  Future<bool> finalizeDetailMember(
      String headerId, List<UserModel> selectedFriend) async {
    bool isResponseFinalized = false;

    try {
      for (var i = 0; i < selectedFriend.length; i++) {
        await supabaseClient.from('TransactionMember').insert({
          'TransactionId': headerId,
          'UserId': selectedFriend[i].id,
        });
      }

      await supabaseClient.from('TransactionHeader').update({
        'IsMemberFinalized': true,
      }).eq('Id', headerId);
      isResponseFinalized = true;
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }

    return isResponseFinalized;
  }

  Future<bool> isSplitted(String headerId) async {
    bool isSplitted = true;
    try {
      final response = await supabaseClient
          .from('TransactionUser')
          .select()
          .eq('TransactionId', headerId) as List;

      if (response.isEmpty) isSplitted = false;
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }

    return isSplitted;
  }

  Future<bool> addTransactionUser(String headerId, String fromUserId,
      String toUserId, double amount) async {
    bool isSucceed = false;
    try {
      await supabaseClient.from('TransactionUser').insert({
        'TransactionId': headerId,
        'FromUserId': fromUserId,
        'ToUserId': toUserId,
        'TotalAmountOwed': amount,
        'HasPaid': false,
      });
      isSucceed = true;
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
    return isSucceed;
  }

  Future deleteAllTransactionUser(String headerId) async {
    try {
      await supabaseClient
          .from('TransactionUser')
          .delete()
          .eq('TransactionId', headerId);
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
  }
}
