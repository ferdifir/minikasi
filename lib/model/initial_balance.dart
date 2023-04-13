class InitialBalance {
  final String name;
  final int code;
  int debit;
  int kredit;

  InitialBalance({
    required this.name,
    required this.code,
    this.debit = 0,
    this.kredit = 0,
  });

  factory InitialBalance.fromDoc(Map<String, dynamic> doc) {
    return InitialBalance(
      name: doc['accountName'],
      code: doc['accountCode'],
      debit: doc['debit'],
      kredit: doc['kredit'],
    );
  }
}
