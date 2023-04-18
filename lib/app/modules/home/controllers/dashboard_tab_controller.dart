import '../../../routes/app_pages.dart';

import '../../../models/transaction_header_model.dart';
import '../../../providers/transactions_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';

class DashboardTabController extends GetxController {
  final strg = Get.find<GetStorage>();
  final _userProvider = UserProvider();
  final _transactionsRepo = TransactionsProvider();
  final recentTrxId = 'recent-transaction';
  List<TransactionHeaderModel> recentTrx = [];

  RxBool isFetching = false.obs;

  Rx<UserModel> userData = UserModel(
    id: '',
    displayName: '',
    email: '',
  ).obs;

  void _toggleIsFetchingTrx(bool newStat) {
    isFetching.value = newStat;
    update([recentTrxId]);
  }

  Future _getUserProfile() async {
    final userFromRepo = await _userProvider.getUserProfile();
    userData.value = userFromRepo;
    update();
  }

  void changeUserProfile(UserModel updatedProfile) {
    userData.value = updatedProfile;
    update();
  }

  void viewTrxDetail(String id) async {
    final selectedHeader = recentTrx.firstWhereOrNull((head) => head.id == id);
    if (selectedHeader != null) {
      if (!selectedHeader.isItemFinalized) {
        Get.toNamed(Routes.ADDTRXITEM, arguments: selectedHeader);
        return;
      }

      if (!selectedHeader.isMemberFinalized) {
        Get.toNamed(Routes.ADDTRXMEMBERS, arguments: selectedHeader);
        return;
      }

      if (!(await _transactionsRepo.isSplitted(selectedHeader.id))) {
        Get.toNamed(Routes.TRXMEMBERWHOPAID, arguments: selectedHeader);
        return;
      }

      Get.toNamed(Routes.TRXDETAIL, arguments: selectedHeader);
    }
  }

  Future _getRecentTransactions() async {
    _toggleIsFetchingTrx(true);
    final trxFromRepo = await _transactionsRepo.getTransactionHeaders(false);
    recentTrx = trxFromRepo.take(3).toList();
    _toggleIsFetchingTrx(false);
  }

  @override
  void onInit() async {
    super.onInit();
    await _getUserProfile();
    await _getRecentTransactions();
  }
}
