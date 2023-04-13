class AccountCode {
  final String name;
  final int code;
  
  AccountCode({
    required this.name,
    required this.code,
  });
  
  factory AccountCode.fromDoc(Map<String,dynamic> doc) {
    return AccountCode(
      name: doc['accountName'],
      code: doc['accountCode'],
    );
  }
}