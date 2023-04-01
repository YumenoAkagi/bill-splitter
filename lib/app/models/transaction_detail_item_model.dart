class TransactionDetailItemModel {
  const TransactionDetailItemModel({
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
    required this.totalPrice,
  });

  final String id;
  final String name;
  final num qty;
  final num price;
  final num totalPrice;
}
