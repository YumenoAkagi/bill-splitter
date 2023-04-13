import 'user_model.dart';

class TrxMemberPaysTheBillModel {
  TrxMemberPaysTheBillModel({
    required this.member,
    required this.paidAmount,
  });

  UserModel member;
  double paidAmount;
}
