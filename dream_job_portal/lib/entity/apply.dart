class Apply{
  final int id;
  final int jobId;
  final String jobTitle;
  final int employerId;
  final String employerName;
  final int jobSeekerId;
  final String jobSeekerName;

  Apply({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.employerId,
    required this.employerName,
    required this.jobSeekerId,
    required this.jobSeekerName,
  });

  factory Apply.fromJson(Map<String, dynamic> json) {
    return Apply(
      id: json['id'],
      jobId: json['jobId'],
      jobTitle: json['jobTitle'],
      employerId: json['employerId'],
      employerName: json['employerName'],
      jobSeekerId: json['jobSeekerId'],
      jobSeekerName: json['jobSeekerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'jobTitle': jobTitle,
      'employerId': employerId,
      'employerName': employerName,
      'jobSeekerId': jobSeekerId,
      'jobSeekerName': jobSeekerName,
    };
  }
}
