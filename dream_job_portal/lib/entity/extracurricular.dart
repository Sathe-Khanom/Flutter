class Extracurricular {
  // Id is optional for new entries, hence nullable
  final int? id;
  final String title;
  final String role;
  final String description;

  Extracurricular({
    this.id,
    required this.title,
    required this.role,
    required this.description,
  });

  // Factory constructor to create an object from JSON (for GET requests)
  factory Extracurricular.fromJson(Map<String, dynamic> json) {
    return Extracurricular(
      id: json['id'],
      title: json['title'] ?? '',
      role: json['role'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // Method to convert the object to JSON format (for POST requests)
  Map<String, dynamic> toJson() {
    return {
      // 'id' is often omitted when creating a new resource (POST)
      if (id != null) 'id': id,
      'title': title,
      'role': role,
      'description': description,
    };
  }
}