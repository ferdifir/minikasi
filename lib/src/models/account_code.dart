class AccountCode {
  final String name;
  final int code;
  final String type;
  
  AccountCode({
    required this.name,
    required this.code,
    required this.type,
  });
  
  factory AccountCode.fromDoc(Map<String,dynamic> doc) {
    return AccountCode(
      name: doc['accountName'],
      code: doc['accountCode'],
      type: doc['accountType'],
    );
  }
}