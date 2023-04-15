import 'user_model.dart';

class TransactionProofModel {
  TransactionProofModel({
    required this.id,
    this.imgUrl,
    required this.paidAmount,
    required this.fromUser,
    required this.toUser,
    required this.createdDate,
  });

  int id;
  String? imgUrl;
  num paidAmount;
  UserModel fromUser;
  UserModel toUser;
  String createdDate;
}
