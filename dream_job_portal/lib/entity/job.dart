class Job {
  final int id;
  final String title;
  final String description;
  final double salary;
  final String jobType;
  final DateTime postedDate;
  final DateTime? endDate;
  final String? keyResponsibility;
  final String? eduRequirement;
  final String? expRequirement;
  final String? benefits;
  final int employerId;
  final String companyName;
  final String contactPerson;
  final String email;
  final String phone;
  final String companyWebsite;
  final String logo;
  final int categoryId;
  final String categoryName;
  final int locationId;
  final String locationName;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.salary,
    required this.jobType,
    required this.postedDate,
    this.endDate,
    this.keyResponsibility,
    this.eduRequirement,
    this.expRequirement,
    this.benefits,
    required this.employerId,
    required this.companyName,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.companyWebsite,
    required this.logo,
    required this.categoryId,
    required this.categoryName,
    required this.locationId,
    required this.locationName,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      salary: (json['salary'] as num).toDouble(),
      jobType: json['jobType'] ?? '',
      postedDate: DateTime.parse(json['postedDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      keyResponsibility: json['keyresponsibility'],
      eduRequirement: json['edurequirement'],
      expRequirement: json['exprequirement'],
      benefits: json['benefits'],
      employerId: json['employerId'],
      companyName: json['companyName'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      companyWebsite: json['companyWebsite'] ?? '',
      logo: json['logo'] ?? '',
      categoryId: json['categoryId'],
      categoryName: json['categoryName'] ?? '',
      locationId: json['locationId'],
      locationName: json['locationName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'salary': salary,
      'jobType': jobType,
      'postedDate': postedDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'keyresponsibility': keyResponsibility,
      'edurequirement': eduRequirement,
      'exprequirement': expRequirement,
      'benefits': benefits,
      'employerId': employerId,
      'companyName': companyName,
      'contactPerson': contactPerson,
      'email': email,
      'phone': phone,
      'companyWebsite': companyWebsite,
      'logo': logo,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'locationId': locationId,
      'locationName': locationName,
    };
  }
}
