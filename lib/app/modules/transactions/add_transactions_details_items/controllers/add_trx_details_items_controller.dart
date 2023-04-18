import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/transaction_detail_item_model.dart';
import '../../../../models/transaction_header_model.dart';
import '../../../../providers/transactions_provider.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/functions_helper.dart';
import '../../../home/controllers/transactions_tab_controller.dart';

class AddTrxDetailsItemsController extends GetxController {
  TransactionHeaderModel trxHeader = Get.arguments as TransactionHeaderModel;
  final _trxRepo = TransactionsProvider();
  final grandTotalController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  Uint8List? selectedImage;

  RxList<TransactionDetailItemModel> detailItemsList =
      List<TransactionDetailItemModel>.empty(growable: true).obs;
  RxBool makeGrandTotalSameAsSubTotal = true.obs;
  RxDouble subtotal = 0.0.obs;
  bool isFetching = false;
  RxBool isLoading = false.obs;
  TransactionDetailItemModel? selectedItem;

  void _toggleFetchingStatus(bool newStat) {
    isFetching = newStat;
    update();
  }

  Future getAllDetailItems() async {
    _toggleFetchingStatus(true);
    detailItemsList.value = await _trxRepo.fetchDetailsItems(trxHeader.id);
    recalculateSubtotal();
    _toggleFetchingStatus(false);
  }

  void recalculateSubtotal() {
    subtotal.value = detailItemsList.fold(0, (prev, e) => prev + e.totalPrice);
  }

  Future<void> removeItem(int id) async {
    TransactionDetailItemModel deletedItem =
        detailItemsList.firstWhere((item) => item.id == id);
    int deletedIdx = -1;
    try {
      _toggleFetchingStatus(true);
      await supabaseClient.from('TransactionDetail').delete().eq('Id', id);
      deletedIdx = detailItemsList.indexWhere((item) => item.id == id);
      detailItemsList.removeAt(deletedIdx);
      recalculateSubtotal();

      showSuccessSnackbar('Success', 'Item successfully deleted.');
    } catch (e) {
      detailItemsList.insert(deletedIdx, deletedItem);
      showUnexpectedErrorSnackbar(e);
    } finally {
      _toggleFetchingStatus(false);
    }
  }

  Future<void> askAddItemMethod() async {
    final result = await showDialog<int>(
      context: Get.context as BuildContext,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Method'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Get.back(result: 1);
            },
            child: Row(
              children: const [
                Icon(
                  FontAwesome.doc_text_inv,
                  size: BUTTON_ICON_SIZE,
                ),
                SizedBox(
                  width: 10 * GOLDEN_RATIO,
                ),
                Text('Scan Receipt'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Get.back(result: 2);
            },
            child: Row(
              children: const [
                Icon(
                  FontAwesome.plus_squared,
                  size: BUTTON_ICON_SIZE,
                ),
                SizedBox(
                  width: 10 * GOLDEN_RATIO,
                ),
                Text('Add item manually'),
              ],
            ),
          ),
        ],
      ),
    );

    if (result == null) return;
    if (result == 1) {
      final imagePickMethod =
          await askImagePickMethod(Get.context as BuildContext);
      if (imagePickMethod == ImagePickMethod.camera) {
        return await proceedImageFromCamera();
      }
      if (imagePickMethod == ImagePickMethod.gallery) {
        return await proceedImageFromGallery();
      }
      return;
    }
    if (result == 2) {
      Get.toNamed('${Routes.ADDTRXITEM}/${Routes.ADDITEMMANUAL}');
      return;
    }
  }

  Future<void> finalizeDetailItems() async {
    if (!(formKey.currentState?.validate() ?? true)) return;

    isLoading.value = true;

    // calculate grand total
    num grandTotal = 0.0;
    if (makeGrandTotalSameAsSubTotal.isTrue) {
      grandTotal = subtotal.value;
    } else {
      grandTotal =
          separatorFormatter.parse(grandTotalController.text).toDouble();
    }

    final isFinalized =
        await _trxRepo.finalizeDetailItem(trxHeader.id, grandTotal);

    if (isFinalized) {
      trxHeader.isItemFinalized = true;
      trxHeader.grandTotal = grandTotal;
      // update list in tab and dashboard
      try {
        final transactionTabController = Get.find<TransactionsTabController>();
        await transactionTabController.getActiveTransactions();
      } catch (e) {
        // do nothing
      }

      isLoading.value = false; // update tab
      Get.offNamed(Routes.ADDTRXMEMBERS, arguments: trxHeader);
    } else {
      isLoading.value = false;
    }
  }

  Future proceedImageFromGallery() async {
    final imgFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (imgFile == null) return;

    try {
      final imgBytes = await imgFile.readAsBytes();
      selectedImage = imgBytes;
      Get.toNamed('${Routes.ADDTRXITEM}/${Routes.ADDITEMOCR}');
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
  }

  Future proceedImageFromCamera() async {
    final imgFile = await _imagePicker.pickImage(source: ImageSource.camera);

    if (imgFile == null) return;

    try {
      final imgBytes = await imgFile.readAsBytes();
      selectedImage = imgBytes;
      Get.toNamed('${Routes.ADDTRXITEM}/${Routes.ADDITEMOCR}');
    } catch (e) {
      showUnexpectedErrorSnackbar(e);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getAllDetailItems();
  }
}
