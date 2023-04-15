import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/transaction_user_model.dart';
import '../../../modules/home/controllers/transactions_tab_controller.dart';
import '../../../modules/transactions/transactions_detail/controllers/transaction_detail_controller.dart';
import '../../../providers/transactions_provider.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/enums.dart';
import '../../../utils/functions_helper.dart';

class BsAddTrxProofController extends GetxController {
  final _trxDetailController = Get.find<TransactionDetailController>();
  final _transactionRepo = TransactionsProvider();
  final _imagePicker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final amountPaidController = TextEditingController();

  RxList<TransactionUserModel> trxUsersList = <TransactionUserModel>[].obs;
  TransactionUserModel? selectedTrxUser;
  RxDouble remainingAmount = 0.0.obs;
  RxBool isLoading = false.obs;
  XFile? selectedImg;

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

  Future pickImage() async {
    final imgPickMethod = await askImagePickMethod(Get.context as BuildContext);
    if (imgPickMethod == ImagePickMethod.camera) {
      final imgFile = await _imagePicker.pickImage(source: ImageSource.camera);
      if (imgFile == null) return;
      _setImageFile(imgFile);
      return;
    }
    if (imgPickMethod == ImagePickMethod.gallery) {
      final imgFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (imgFile == null) return;
      _setImageFile(imgFile);
      return;
    }
  }

  void _setImageFile(XFile? imgFile) {
    selectedImg = imgFile;
    update();
  }

  Future addTransactionProof() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      String? imgUrl;
      if (selectedImg != null) {
        final bytes = await selectedImg!.readAsBytes();
        final fileExt = selectedImg!.path.split('.').last;
        final newFileName = 'TP-${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = newFileName; // change path if necessary

        await supabaseClient.storage
            .from('transactionproof')
            .uploadBinary(filePath, bytes);

        imgUrl = supabaseClient.storage
            .from('transactionproof')
            .getPublicUrl(filePath);
      }

      final amountPaid =
          separatorFormatter.parse(amountPaidController.text).toDouble();
      final totalAmountPaid = selectedTrxUser!.amountPaid + amountPaid;
      final bool hasPaid =
          (totalAmountPaid >= selectedTrxUser!.totalAmountOwed);
      final succeed = await _transactionRepo.addTransactionProof(
        selectedTrxUser!.id,
        amountPaid,
        totalAmountPaid,
        hasPaid,
        imgUrl,
      );
      if (!succeed) return;
      await _transactionRepo
          .updateStatusOnTrxHeader(_trxDetailController.trxHeader.id);

      await _trxDetailController.calculateRemainingDebtsReceivables();
      await _trxDetailController.fetchTransactionUser();

      try {
        final transactionTabController = Get.find<TransactionsTabController>();
        await transactionTabController.getActiveTransactions();
      } catch (e) {
        // do nothing
      }

      Get.back();
      showSuccessSnackbar(
          'Success', 'Payment Confirmation successfully added.');
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await _refreshDebts();
  }
}
