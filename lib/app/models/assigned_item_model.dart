import 'transaction_detail_item_model.dart';
import 'user_model.dart';

class AssignedItemModel {
  AssignedItemModel({
    required this.item,
    this.assignedMembers,
  });

  TransactionDetailItemModel item;
  List<UserModel>? assignedMembers;
}
