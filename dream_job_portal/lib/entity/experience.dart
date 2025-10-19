// lib/models/experience.dart
class Experience {
  final int? id; // nullable for new experiences
  final String company;
  final String position;
  final String? fromDate;
  final String? toDate;
  final String? description;

  Experience({
    this.id, // Changed to nullable
    required this.company,
    required this.position,
    this.fromDate,
    this.toDate,
    this.description,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    // API data structure: companyName, jobTitle, startDate, endDate
    // Your current model: company, position, fromDate, toDate

    // We must map API keys to your Dart model keys for consistent usage
    return Experience(
      id: json['id'],
      company: json['companyName'] ?? json['company'] ?? '', // Use API key if available
      position: json['jobTitle'] ?? json['position'] ?? '', // Use API key if available
      fromDate: json['startDate'] ?? json['fromDate'],
      toDate: json['endDate'] ?? json['toDate'],
      description: json['description'],
    );
  }

  // --- Crucial addition for sending data to the API ---
  Map<String, dynamic> toJson() {
    // We map your Dart model keys (company, position, etc.) 
    // to the API's expected keys (companyName, jobTitle, etc.)
    return {
      'id': id,
      'companyName': company, // API expects companyName
      'jobTitle': position,   // API expects jobTitle
      'startDate': fromDate,  // API expects startDate
      'endDate': toDate,      // API expects endDate
      'description': description,
    };
  }
}