class TransactionHeader {
  TransactionHeader({
    required this.id,
    required this.name,
    required this.date,
    this.isComplete,
    this.grandTotal = 0,
    this.isMemberFinalized,
    this.isDeletable,
  });

  final String id;
  final String name;
  final String date;
  bool? isComplete;
  num grandTotal;
  bool? isMemberFinalized;
  bool? isDeletable;
}
