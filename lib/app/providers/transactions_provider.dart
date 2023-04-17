import 'package:bill_splitter/app/models/transaction_proof_model.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/transaction_detail_item_model.dart';
import '../models/transaction_header_model.dart';
import '../models/transaction_user_model.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';
import '../utils/functions_helper.dart';

class TransactionsProvider {
  Future<TransactionHeaderModel?> getTransactionHeader(String headerId) async {
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

    final selectedTrx = TransactionHeaderModel(
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

  Future<List<UserModel>> getTransactionMembers(String headerId) async {
    final List<UserModel> membersList = [];
    try {
      final response = await supabaseClient
          .from('TransactionMember')
          .select('Users!inner(*)')
          .eq('TransactionId', headerId);

      response.forEach((tm) {
        membersList.add(
          UserModel(
            id: tm['Users']['Id'],
            displayName: tm['Users']['DisplayName'],
            email: tm['Users']['Email'],
            profilePicUrl: tm['Users']['ProfilePictureURL'],
          ),
        );
      });
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
    return membersList;
  }

  Future<List<TransactionHeaderModel>> getTransactionHeaders(
      bool isComplete) async {
    final List<TransactionHeaderModel> headersList = [];
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
          TransactionHeaderModel(
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

  Future<bool> editDetailsItem(
      int id, String name, double price, double qty, double totalPrice) async {
    bool isEdited = false;
    try {
      await supabaseClient.from('TransactionDetail').update({
        'Price': price,
        'Name': name,
        'Quantity': qty,
        'TotalPrice': totalPrice,
      }).eq('Id', id);
      isEdited = true;
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }

    return isEdited;
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

  Future<double> getTotalDebtsForCurrentUser(
      String userId, String headerId) async {
    double totalDebts = 0.0;

    try {
      final response = await supabaseClient
          .from('TransactionUser')
          .select()
          .eq('TransactionId', headerId)
          .eq('FromUserId', userId);

      response.forEach(
          (tu) => totalDebts += (tu['TotalAmountOwed'] - tu['AmountPaid']));
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }

    return totalDebts;
  }

  Future<List<TransactionUserModel>> getUserDebts(
      String headerId, String userId) async {
    List<TransactionUserModel> debts = [];
    try {
      final response = await supabaseClient
          .from('TransactionUser')
          .select('*,fromUser:Users!FromUserId(*),toUser:Users!ToUserId(*)')
          .eq('TransactionId', headerId)
          .eq('FromUserId', userId)
          .eq('HasPaid', false);

      response.forEach(
        (res) => debts.add(
          TransactionUserModel(
            id: res['Id'],
            fromUser: UserModel(
              id: res['fromUser']['Id'],
              displayName: res['fromUser']['DisplayName'],
              email: res['fromUser']['Email'],
              profilePicUrl: res['fromUser']['ProfilePictureURL'],
            ),
            toUser: UserModel(
              id: res['toUser']['Id'],
              displayName: res['toUser']['DisplayName'],
              email: res['toUser']['Email'],
              profilePicUrl: res['toUser']['ProfilePictureURL'],
            ),
            totalAmountOwed: res['TotalAmountOwed'],
            amountPaid: res['AmountPaid'],
          ),
        ),
      );
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }

    return debts;
  }

  Future<List<TransactionUserModel>> getTransactionUsers(
      String headerId, String userId) async {
    List<TransactionUserModel> transactionUsersList = [];
    try {
      final response = await supabaseClient
          .from('TransactionUser')
          .select('*,fromUser:Users!FromUserId(*),toUser:Users!ToUserId(*)')
          .eq('TransactionId', headerId)
          .or('FromUserId.eq.$userId,ToUserId.eq.$userId');

      response.forEach(
        (tu) => transactionUsersList.add(
          TransactionUserModel(
            id: tu['Id'],
            fromUser: UserModel(
              id: tu['fromUser']['Id'],
              displayName: tu['fromUser']['DisplayName'],
              email: tu['fromUser']['Email'],
              profilePicUrl: tu['fromUser']['ProfilePictureURL'],
            ),
            toUser: UserModel(
              id: tu['toUser']['Id'],
              displayName: tu['toUser']['DisplayName'],
              email: tu['toUser']['Email'],
              profilePicUrl: tu['toUser']['ProfilePictureURL'],
            ),
            totalAmountOwed: tu['TotalAmountOwed'],
            amountPaid: tu['AmountPaid'],
          ),
        ),
      );
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }

    return transactionUsersList;
  }

  Future<double> getTotalReceivablesForCurrentUser(
      String userId, String headerId) async {
    double totalReceivables = 0.0;

    try {
      final response = await supabaseClient
          .from('TransactionUser')
          .select()
          .eq('TransactionId', headerId)
          .eq('ToUserId', userId);

      response.forEach(
        (tu) => totalReceivables += (tu['TotalAmountOwed'] - tu['AmountPaid']),
      );
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }

    return totalReceivables;
  }

  Future<bool> addTransactionProof(int transactionUserId, double amountPaid,
      double totalAmountPaid, bool hasPaid, String? imgUrl) async {
    bool isSucceed = false;

    try {
      await supabaseClient.from('TransactionProof').insert({
        'ImageURL': imgUrl,
        'TransactionUserId': transactionUserId,
        'AmountPaid': amountPaid,
      });

      // update transactionUser
      await supabaseClient.from('TransactionUser').update({
        'AmountPaid': totalAmountPaid,
        'HasPaid': hasPaid,
      }).eq('Id', transactionUserId);
      isSucceed = true;
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }

    return isSucceed;
  }

  Future updateStatusOnTrxHeader(String headerId) async {
    try {
      final response = await supabaseClient
          .from('TransactionUser')
          .select<PostgrestListResponse>(
              '*', const FetchOptions(count: CountOption.exact))
          .eq('TransactionId', headerId)
          .eq('HasPaid', false);

      if ((response.count ?? 0) <= 0) {
        await supabaseClient
            .from('TransactionHeader')
            .update({'IsComplete': true}).eq('Id', headerId);
      }

      await supabaseClient
          .from('TransactionHeader')
          .update({'IsDeletable': false}).eq('Id', headerId);
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
  }

  Future<List<TransactionProofModel>> getUserTransactionProofs(
      String headerId, String userId) async {
    final List<TransactionProofModel> proofs = [];
    try {
      final response = await supabaseClient
          .from('TransactionProof')
          .select<PostgrestListResponse>(
            '*,TransactionUser!inner(*)',
            const FetchOptions(count: CountOption.exact),
          )
          .eq('TransactionUser.TransactionId', headerId);

      for (int i = 0; i < (response.count ?? 0); i++) {
        final trxUserResponse = await supabaseClient
            .from('TransactionUser')
            .select('fromUser:Users!FromUserId(*),toUser:Users!ToUserId(*)')
            .eq(
              'Id',
              response.data![i]['TransactionUser']['Id'],
            )
            .or('FromUserId.eq.$userId,ToUserId.eq.$userId')
            .single();

        proofs.add(
          TransactionProofModel(
            id: response.data![i]['id'],
            paidAmount: response.data![i]['AmountPaid'],
            fromUser: UserModel(
                id: trxUserResponse['fromUser']['Id'],
                displayName: trxUserResponse['fromUser']['DisplayName'],
                email: trxUserResponse['fromUser']['Email'],
                profilePicUrl: trxUserResponse['fromUser']
                    ['ProfilePictureURL']),
            toUser: UserModel(
              id: trxUserResponse['toUser']['Id'],
              displayName: trxUserResponse['toUser']['DisplayName'],
              email: trxUserResponse['toUser']['Email'],
              profilePicUrl: trxUserResponse['toUser']['ProfilePictureURL'],
            ),
            imgUrl: response.data![i]['ImageURL'],
            createdDate: DateFormat('dd MMM yyyy - hh:mm:ss a')
                .format(DateTime.parse(response.data![i]['created_at'])),
          ),
        );
      }
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
    return proofs;
  }
}
