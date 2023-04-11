import 'user_model.dart';

class TransactionUserModel {
  TransactionUserModel({
    required this.id,
    required this.fromUser,
    required this.toUser,
    required this.totalAmountOwed,
    required this.amountPaid,
  });

  int id;
  UserModel fromUser;
  UserModel toUser;
  num totalAmountOwed;
  num amountPaid;
}
