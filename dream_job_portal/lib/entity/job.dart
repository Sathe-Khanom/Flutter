class Job {
  final int id;
  final String title;
  final String description;
  final String location;
  final double salary;
  final String jobType;
  final DateTime postedDate;
  final DateTime endDate;
  final String keyResponsibility;
  final String eduRequirement;
  final String expRequirement;
  final String benefits;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.postedDate,
    required this.endDate,
    required this.keyResponsibility,
    required this.eduRequirement,
    required this.expRequirement,
    required this.benefits,
  });

  // JSON থেকে Job object তৈরি করা
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      salary: (json['salary'] as num).toDouble(),
      jobType: json['jobType'],
      postedDate: DateTime.parse(json['postedDate']),
      endDate: DateTime.parse(json['endDate']),
      keyResponsibility: json['keyresponsibility'],
      eduRequirement: json['edurequirement'],
      expRequirement: json['exprequirement'],
      benefits: json['benefits'],
    );
  }

  // Job object কে JSON এ রূপান্তর করা
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'salary': salary,
      'jobType': jobType,
      'postedDate': postedDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'keyresponsibility': keyResponsibility,
      'edurequirement': eduRequirement,
      'exprequirement': expRequirement,
      'benefits': benefits,
    };
  }
}
