class Employer {
  final int? id;
  final String? companyName;
  final String? contactPerson;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? companyAddress;
  final String? companyWebsite;
  final String? industryType;
  final String? logo;

  Employer({
    this.id,
    this.companyName,
    this.contactPerson,
    this.email,
    this.password,
    this.phoneNumber,
    this.companyAddress,
    this.companyWebsite,
    this.industryType,
    this.logo,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      id: json['id'],
      companyName: json['companyName'],
      contactPerson: json['contactPerson'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      companyAddress: json['companyAddress'],
      companyWebsite: json['companyWebsite'],
      industryType: json['industryType'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'contactPerson': contactPerson,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'companyAddress': companyAddress,
      'companyWebsite': companyWebsite,
      'industryType': industryType,
      'logo': logo,
    };
  }
}
