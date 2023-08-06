class InitialBalance {
  final int kodeAkun;
  final int kredit;
  final int debit;

  InitialBalance({
    required this.kodeAkun,
    required this.kredit,
    required this.debit,
  });

  factory InitialBalance.fromDoc(Map<String, dynamic> json) {
    return InitialBalance(
      kodeAkun: json['accountCode'],
      kredit: json['kredit'],
      debit: json['debit'],
    );
  }
}