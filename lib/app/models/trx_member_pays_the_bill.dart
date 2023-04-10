import 'user_model.dart';

class TrxMemberPaysTheBill {
  TrxMemberPaysTheBill({
    required this.member,
    required this.paidAmount,
  });

  UserModel member;
  double paidAmount;
}
