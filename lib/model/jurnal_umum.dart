class JurnalUmum {
  final String date;
  final int debit;
  final int kredit;
  final int accountCode;
  final String accountName;
  final String description;

  JurnalUmum({
    required this.date,
    required this.debit,
    required this.kredit,
    required this.accountCode,
    required this.accountName,
    required this.description,
  });

  factory JurnalUmum.fromDoc(Map<String, dynamic> json) {
    return JurnalUmum(
      date: json['date'],
      debit: json['debit'],
      kredit: json['kredit'],
      accountCode: json['accountCode'],
      accountName: json['accountName'],
      description: json['description'],
    );
  }
}
