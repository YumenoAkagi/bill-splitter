class TransactionDetailItemModel {
  TransactionDetailItemModel({
    required this.id,
    required this.transactionId,
    required this.name,
    required this.qty,
    required this.price,
    required this.totalPrice,
  });

  int id;
  String transactionId;
  String name;
  num qty;
  num price;
  num totalPrice;
}
