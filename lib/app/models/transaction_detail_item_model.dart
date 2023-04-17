class TransactionDetailItemModel {
  TransactionDetailItemModel({
    required this.id,
    required this.transactionId,
    required this.name,
    required this.qty,
    required this.price,
    required this.totalPrice,
    this.discount = 0,
  });

  int id;
  String transactionId;
  String name;
  num qty;
  num price;
  num totalPrice;
  num discount;
}
