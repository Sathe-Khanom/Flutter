class Training {
  final int? id; // id can remain final as it's typically set by the backend
  String title; // Removed final
  String institute; // Removed final
  String duration; // Removed final
  String description; // Removed final

  Training({
    this.id,
    required this.title,
    required this.institute,
    required this.duration,
    required this.description,
  });

  // ... rest of the class (fromJson, toJson) remains the same
  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'],
      title: json['title'],
      institute: json['institute'],
      duration: json['duration'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include id for update operation
      'title': title,
      'institute': institute,
      'duration': duration,
      'description': description,
    };
  }
}