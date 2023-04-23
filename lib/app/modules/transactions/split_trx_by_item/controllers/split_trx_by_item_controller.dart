import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../models/assigned_item_model.dart';
import '../../../../models/transaction_header_model.dart';
import '../../../../models/trx_member_pays_the_bill_model.dart';
import '../../../../models/user_model.dart';
import '../../../../providers/transactions_provider.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/functions_helper.dart';
import '../../../home/controllers/transactions_tab_controller.dart';
import '../../who_paid_trx_bill/controllers/who_paid_trx_bill_controller.dart';

class SplitTrxByItemController extends GetxController {
  TransactionHeaderModel trxHeader = Get.arguments as TransactionHeaderModel;
  final _transactionRepo = TransactionsProvider();
  List<AssignedItemModel> assignedItemMemberList = [];
  List<UserModel> memberList = [];

  AssignedItemModel? selectedAssignItem;

  bool isFetching = false;

  void _toggleFetchingStatus(bool newStat) {
    isFetching = newStat;
    update();
  }

  Future _getTransactionDetails() async {
    _toggleFetchingStatus(true);
    final itemList = await _transactionRepo.fetchDetailsItems(trxHeader.id);
    for (var item in itemList) {
      assignedItemMemberList.add(AssignedItemModel(item: item));
    }
    _toggleFetchingStatus(false);
  }

  Future _getTransactionMembers() async {
    _toggleFetchingStatus(true);
    memberList = await _transactionRepo.getTransactionMembers(trxHeader.id);
    _toggleFetchingStatus(false);
  }

  Future finalizeAndCalculate() async {
    if (assignedItemMemberList
        .any((ai) => (ai.assignedMembers?.length ?? 0) <= 0)) {
      showErrorSnackbar('There are item(s) not yet assigned to any member.');
      return;
    }

    final ctx = Get.context as BuildContext;
    ctx.loaderOverlay.show();
    List<String> memberIds = [];

    for (var i = 0; i < trxHeader.membersList.length; i++) {
      memberIds.add(trxHeader.membersList[i].id);
    }
    try {
      final whoPaidController = Get.find<WhoPaidTrxBillController>();
      final membersWhoPaidBill = whoPaidController.membersWhoPaidBill;
      final initialTotalPaymentAmount = assignedItemMemberList.fold(
          0.0, (prev, ai) => prev + ai.item.totalPrice);
      final payers = membersWhoPaidBill.map((mw) => mw.member).toList();
      List<UserModel> membersNotPay = memberList;
      for (var payer in payers) {
        membersNotPay.removeWhere((mem) => mem.id == payer.id);
      }

      bool isSucceed = true;
      List<TrxMemberPaysTheBillModel> surplusMembers = [];
      List<TrxMemberPaysTheBillModel> debtsMembers = [];
      double totalSurplus = 0.0;

      for (var i = 0; i < membersWhoPaidBill.length; i++) {
        final currentPaidMember = membersWhoPaidBill[i];
        final itemsBought = assignedItemMemberList.where((ai) =>
            (ai.assignedMembers
                ?.any((mem) => mem.id == currentPaidMember.member.id)) ??
            false);
        final initialPaymentAmount = itemsBought.fold(
            0.0,
            (prev, ai) =>
                prev + ai.item.totalPrice / ai.assignedMembers!.length);
        final mustPayAmount = initialPaymentAmount /
            initialTotalPaymentAmount *
            trxHeader.grandTotal;
        // if amount paid sufficient
        final debtsOrSurplusAmount =
            currentPaidMember.paidAmount - mustPayAmount;

        if (debtsOrSurplusAmount > 0.0) {
          surplusMembers.add(currentPaidMember);
          totalSurplus += debtsOrSurplusAmount;
        } else if (debtsOrSurplusAmount < 0.0) {
          debtsMembers.add(currentPaidMember);
        }
      }

      for (var i = 0; i < surplusMembers.length; i++) {
        final currentSurplusMember = surplusMembers[i];
        final itemsBought = assignedItemMemberList.where((ai) =>
            (ai.assignedMembers
                ?.any((mem) => mem.id == currentSurplusMember.member.id)) ??
            false);
        final initialPaymentAmount = itemsBought.fold(
            0.0,
            (prev, ai) =>
                prev + ai.item.totalPrice / ai.assignedMembers!.length);
        final mustPayAmount = initialPaymentAmount /
            initialTotalPaymentAmount *
            trxHeader.grandTotal;
        final surplusAmount = currentSurplusMember.paidAmount - mustPayAmount;
        // all member who did not pay or not sufficient must pay this member
        // member who not pay at all
        for (var j = 0; j < membersNotPay.length; j++) {
          final currentMember = membersNotPay[j];

          final mem_itemsBought = assignedItemMemberList.where((ai) =>
              (ai.assignedMembers?.any((mem) => mem.id == currentMember.id)) ??
              false);
          final mem_initialPaymentAmount = mem_itemsBought.fold(
              0.0,
              (prev, ai) =>
                  prev + ai.item.totalPrice / ai.assignedMembers!.length);
          final mem_mustPayAmount = mem_initialPaymentAmount /
              initialTotalPaymentAmount *
              trxHeader.grandTotal;

          isSucceed = await _transactionRepo.addTransactionUser(
            trxHeader.id,
            currentMember.id,
            currentSurplusMember.member.id,
            surplusAmount / totalSurplus * mem_mustPayAmount,
          );
        }
        // member who paid but not sufficient
        for (var j = 0; j < debtsMembers.length; j++) {
          final currentMember = debtsMembers[j];
          final mem_itemsBought = assignedItemMemberList.where((ai) =>
              (ai.assignedMembers
                  ?.any((mem) => mem.id == currentMember.member.id)) ??
              false);
          final mem_initialPaymentAmount = mem_itemsBought.fold(
              0.0,
              (prev, ai) =>
                  prev + ai.item.totalPrice / ai.assignedMembers!.length);
          final mem_mustPayAmount = mem_initialPaymentAmount /
              initialTotalPaymentAmount *
              trxHeader.grandTotal;
          final mem_remainingPaymentAmount =
              (currentMember.paidAmount - mem_mustPayAmount).abs();

          isSucceed = await _transactionRepo.addTransactionUser(
            trxHeader.id,
            currentMember.member.id,
            currentSurplusMember.member.id,
            (surplusAmount / totalSurplus * mem_remainingPaymentAmount)
                .ceilToDouble(),
          );
        }
        if (!isSucceed) {
          // revert
          await _transactionRepo.deleteAllTransactionUser(trxHeader.id);
          return;
        }
      }
      try {
        final transactionTabController = Get.find<TransactionsTabController>();
        await transactionTabController.getActiveTransactions();
      } catch (e) {
        // do nothing
      }
      await sendNotification(
        memberIds,
        'New Transaction Created',
        'A new transaction has been created!',
      );
      Get.offNamed(Routes.SPLITSUCCESS);
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    } finally {
      ctx.loaderOverlay.hide();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await _getTransactionDetails();
    await _getTransactionMembers();
  }
}
