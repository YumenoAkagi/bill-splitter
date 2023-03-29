class TransactionHeader {
  TransactionHeader({
    required this.Id,
    required this.Name,
    required this.Date,
    this.IsComplete,
    this.GrandTotal,
    this.IsMemberFinalized,
    this.IsDeletable,
  });

  String Id;
  String Name;
  String Date;
  bool? IsComplete;
  double? GrandTotal;
  bool? IsMemberFinalized;
  bool? IsDeletable;
}
