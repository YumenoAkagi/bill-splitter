import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../modules/transactions/split_trx_by_item/controllers/split_trx_by_item_controller.dart';

class BsAssignItemMemberController extends GetxController {
  final splitTrxByItemController = Get.find<SplitTrxByItemController>();
  RxList<UserModel> memberList = <UserModel>[].obs;
  RxList<UserModel> selectedMember = <UserModel>[].obs;

  void _initMember() {
    memberList.value = splitTrxByItemController.memberList;
    selectedMember.value =
        splitTrxByItemController.selectedAssignItem?.assignedMembers ?? [];
  }

  void _assignMembertoItem() {
    final selected = splitTrxByItemController.assignedItemMemberList
        .firstWhereOrNull(
            (ai) => ai == splitTrxByItemController.selectedAssignItem);
    if (selected != null) {
      selected.assignedMembers = selectedMember;
    }

    splitTrxByItemController.update();
  }

  @override
  void onInit() {
    super.onInit();
    _initMember();
  }

  @override
  void onClose() {
    _assignMembertoItem();
    super.onClose();
  }
}
