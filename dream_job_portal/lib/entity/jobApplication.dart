
class JobApplication {
  final int id;
  final int jobId;
  final String jobTitle;
  final int employerId;
  final String employerName;
  final int jobSeekerId;
  final String jobSeekerName;




  JobApplication({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.employerId,
    required this.employerName,
    required this.jobSeekerId,
    required this.jobSeekerName,
  });



  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'],
      jobId: json['jobId'],
      jobTitle: json['jobTitle'],
      employerId: json['employerId'],
      employerName: json['employerName'],
      jobSeekerId: json['jobSeekerId'],
      jobSeekerName: json['jobSeekerName'],
    );
  }
}
