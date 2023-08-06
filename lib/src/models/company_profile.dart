class CompanyProfile {
  final String ownerCompany;
  final String nameCompany;
  final String phoneCompany;
  final String addressCompany;
  final String emailCompany;

  CompanyProfile({
    required this.ownerCompany,
    required this.nameCompany,
    required this.phoneCompany,
    required this.addressCompany,
    required this.emailCompany,
  });

  factory CompanyProfile.fromMap(Map<String, dynamic> map) {
    return CompanyProfile(
      ownerCompany: map['ownerCompany'],
      nameCompany: map['nameCompany'],
      phoneCompany: map['phoneCompany'],
      addressCompany: map['addressCompany'],
      emailCompany: map['emailCompany'],
    );
  }
}
