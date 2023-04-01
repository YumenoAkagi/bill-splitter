class TransactionHeader {
  TransactionHeader({
    required this.id,
    required this.name,
    required this.date,
    this.isComplete = false,
    this.grandTotal = 0,
    this.isMemberFinalized = false,
    this.isItemFinalized = false,
    this.isDeletable = true,
  });

  final String id;
  final String name;
  final String date;
  bool? isComplete;
  num grandTotal;
  bool? isMemberFinalized;
  bool? isItemFinalized;
  bool? isDeletable;
}